import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class LawyerProfileScreen extends StatelessWidget {
  const LawyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Lawyer profile will appear here.'),
      ),
    );
  }
}
