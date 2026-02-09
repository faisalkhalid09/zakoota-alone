import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';

/// Lawyer main wrapper with bottom navigation
class LawyerMainWrapper extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const LawyerMainWrapper({super.key, required this.navigationShell});

  @override
  State<LawyerMainWrapper> createState() => _LawyerMainWrapperState();
}

class _LawyerMainWrapperState extends State<LawyerMainWrapper> {
  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.secondary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontFamily: AppTextStyles.bodyFont,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: AppTextStyles.bodyFont,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: PhosphorIcon(PhosphorIconsRegular.squaresFour),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: PhosphorIcon(PhosphorIconsRegular.briefcase),
                label: 'My Cases',
              ),
              BottomNavigationBarItem(
                icon: PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
                label: 'Job Board',
              ),
              BottomNavigationBarItem(
                icon: PhosphorIcon(PhosphorIconsRegular.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
