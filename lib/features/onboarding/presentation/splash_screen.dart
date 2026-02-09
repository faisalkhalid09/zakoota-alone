import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

/// Splash Screen with animated logo
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Start fade-in animation
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _opacity = 1.0;
      });
    }

    // Wait for 2 seconds total
    await Future.delayed(const Duration(milliseconds: 1700));

    // Mock auth check (always false for now)
    final isAuthenticated = await _checkAuthentication();

    if (mounted) {
      if (isAuthenticated) {
        // TODO: Navigate to dashboard when auth is implemented
        context.go('/welcome');
      } else {
        context.go('/onboarding');
      }
    }
  }

  Future<bool> _checkAuthentication() async {
    // Mock authentication check
    // TODO: Replace with actual Firebase auth check
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.secondary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Z',
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // App Name
              Text(
                'ZAKOOTA',
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Tagline
              Text(
                'Legal Services Marketplace',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
