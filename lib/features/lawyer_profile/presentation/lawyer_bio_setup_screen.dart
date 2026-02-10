import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

class LawyerBioSetupScreen extends StatefulWidget {
  const LawyerBioSetupScreen({super.key});

  @override
  State<LawyerBioSetupScreen> createState() => _LawyerBioSetupScreenState();
}

class _LawyerBioSetupScreenState extends State<LawyerBioSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _firestore = FirebaseFirestore.instance;

  final _nameController = TextEditingController();
  final _headingController =
      TextEditingController(); // e.g. Senior Criminal Lawyer
  final _bioController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _consultationRateController =
      TextEditingController(); // Per consultation/case

  String? _selectedCity;
  bool _isLoading = false;

  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && mounted) {
          final data = userDoc.data();
          setState(() {
            if (data != null) {
              _nameController.text = data['fullName'] ?? '';
              _headingController.text = data['professionalHeading'] ?? '';
              _bioController.text = data['bio'] ?? '';
              _hourlyRateController.text =
                  (data['hourlyRate'] ?? '').toString();
              _consultationRateController.text =
                  (data['consultationRate'] ?? '').toString();
              _selectedCity =
                  data['city']; // Pre-fill city if available from signup
            }
          });
        }
      } catch (e) {
        debugPrint('Error loading user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headingController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    _consultationRateController.dispose();
    super.dispose();
  }

  Future<void> _saveBio() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select your city of availability')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final userId = _authService.currentUser!.uid;

        await _firestore.collection('users').doc(userId).update({
          'fullName': _nameController.text.trim(),
          'professionalHeading': _headingController.text.trim(),
          'bio': _bioController.text.trim(),
          'hourlyRate':
              double.tryParse(_hourlyRateController.text.trim()) ?? 0.0,
          'consultationRate':
              double.tryParse(_consultationRateController.text.trim()) ?? 0.0,
          'city': _selectedCity,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          context.go('/lawyer-photo-upload');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving bio: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Public Profile Setup'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Introduce Yourself',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This information will be visible to potential clients.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Heading
                TextFormField(
                  controller: _headingController,
                  decoration: const InputDecoration(
                    labelText: 'Professional Heading',
                    hintText: 'e.g. Senior Criminal Defense Lawyer',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title_outlined),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // City
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(
                    labelText: 'City of Availability',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _cities.map((city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCity = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Bio
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Biography / About Me',
                    hintText:
                        'Tell clients about your experience and expertise...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Rates Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hourlyRateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hourly Rate (PKR)',
                          prefixText: 'Rs. ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (double.tryParse(value) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _consultationRateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Consultation Fee',
                          prefixText: 'Rs. ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (double.tryParse(value) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveBio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Next: Upload Photo',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
