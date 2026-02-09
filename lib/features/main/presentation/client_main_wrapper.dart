import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';

/// Main wrapper for client screens with bottom navigation bar
class ClientMainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ClientMainWrapper({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
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
        child: BottomNavigationBar(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          selectedLabelStyle: const TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: AppTextStyles.bodyFont,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIconsRegular.house,
                size: 24,
              ),
              activeIcon: PhosphorIcon(
                PhosphorIconsFill.house,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIconsRegular.briefcase,
                size: 24,
              ),
              activeIcon: PhosphorIcon(
                PhosphorIconsFill.briefcase,
                size: 24,
              ),
              label: 'My Cases',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIconsRegular.chatCircleText,
                size: 24,
              ),
              activeIcon: PhosphorIcon(
                PhosphorIconsFill.chatCircleText,
                size: 24,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIconsRegular.user,
                size: 24,
              ),
              activeIcon: PhosphorIcon(
                PhosphorIconsFill.user,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
