import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class LawyerEditProfileScreen extends StatefulWidget {
  const LawyerEditProfileScreen({super.key});

  @override
  State<LawyerEditProfileScreen> createState() =>
      _LawyerEditProfileScreenState();
}

class _LawyerEditProfileScreenState extends State<LawyerEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  final _imagePicker = ImagePicker();

  // Controllers
  final _nameController = TextEditingController();
  final _bioController = TextEditingController(); // About Me
  final _hourlyRateController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();

  // State
  bool _isLoading = true;
  bool _isSaving = false;
  XFile? _newProfileImage;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['fullName'] ?? '';
        _bioController.text = data['aboutMe'] ?? '';
        _hourlyRateController.text = (data['hourlyRate'] ?? '').toString();
        _experienceController.text = (data['experienceYears'] ?? '').toString();
        _locationController.text = data['location'] ?? '';
        _currentPhotoUrl = data['photoUrl'];
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _newProfileImage = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not logged in');

      // 1. Upload new photo if selected
      if (_newProfileImage != null) {
        await _authService.uploadProfilePhoto_Lawyer(
            user.uid, _newProfileImage!);
      }

      // 2. Update Firestore Data
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': _nameController.text.trim(),
        'aboutMe': _bioController.text.trim(),
        'hourlyRate': int.tryParse(_hourlyRateController.text) ?? 5000,
        'experienceYears': int.tryParse(_experienceController.text) ?? 0,
        'location': _locationController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(); // Go back to profile screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Photo Picker
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 2,
                        ),
                        image: _newProfileImage != null
                            ? DecorationImage(
                                image: kIsWeb
                                    ? NetworkImage(_newProfileImage!.path)
                                    : FileImage(File(_newProfileImage!.path))
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : (_currentPhotoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(_currentPhotoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child:
                          (_newProfileImage == null && _currentPhotoUrl == null)
                              ? const Icon(Icons.person,
                                  size: 60, color: Colors.grey)
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          PhosphorIconsRegular.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Form Fields
              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: (v) =>
                    v?.isEmpty == true ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(
                label: 'Location (City, Country)',
                controller: _locationController,
                icon: PhosphorIconsRegular.mapPin,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Hourly Rate (PKR)',
                      controller: _hourlyRateController,
                      keyboardType: TextInputType.number,
                      icon: PhosphorIconsRegular.currencyDollar,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildTextField(
                      label: 'Experience (Years)',
                      controller: _experienceController,
                      keyboardType: TextInputType.number,
                      icon: PhosphorIconsRegular.briefcase,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTextField(
                label: 'About Me (Bio)',
                controller: _bioController,
                maxLines: 4,
                hint:
                    'Tell clients about your expertise, background, and approach...',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
