import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/lawyer_welcome.dart';
import '../../features/auth/presentation/lawyer_signup_screen.dart';
import '../../features/verification/presentation/verification_screen.dart';
import '../../features/verification/presentation/pending_screen.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/client_home_screen.dart';
import '../../features/cases/presentation/my_cases_screen.dart';
import '../../features/cases/presentation/case_details_screen.dart';
import '../../features/chat/presentation/conversations_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/main/presentation/client_main_wrapper.dart';
import '../../features/lawyers/presentation/lawyer_search_screen.dart';
import '../../features/lawyers/presentation/lawyer_profile_screen.dart'
    as client_lawyer;
import '../../features/wallet/presentation/wallet_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/booking/presentation/booking_summary_screen.dart';
import '../../features/cases/presentation/create_case_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/lawyers/data/lawyer_mock_data.dart';
import '../../features/lawyer_dashboard/presentation/lawyer_main_wrapper.dart';
import '../../features/lawyer_dashboard/presentation/lawyer_home_screen.dart';
import '../../features/lawyer_cases/presentation/lawyer_cases_screen.dart';
import '../../features/jobs/presentation/job_board_screen.dart';
import '../../features/jobs/presentation/job_details_screen.dart';
import '../../features/jobs/data/job_mock_data.dart';
import '../../features/lawyer_dashboard/presentation/lawyer_profile_screen.dart'
    as portal_lawyer;
import '../../features/lawyer_portal/presentation/lawyer_dashboard_screen.dart';
import '../../features/profile/presentation/saved_lawyers_screen.dart';
import '../../features/profile/presentation/security_settings_screen.dart';
import '../../features/profile/presentation/language_settings_screen.dart';
import '../../features/profile/presentation/help_center_screen.dart';
import '../../features/profile/presentation/terms_privacy_screen.dart';

/// GoRouter configuration for the app
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Splash Screen (Root)
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Screen
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Welcome/Role Selection Screen
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    // Lawyer Welcome Screen
    GoRoute(
      path: '/lawyer-welcome',
      name: 'lawyer-welcome',
      builder: (context, state) => const LawyerWelcomeScreen(),
    ),

    // Lawyer Sign Up Screen
    GoRoute(
      path: '/lawyer-signup',
      name: 'lawyer-signup',
      builder: (context, state) => const LawyerSignUpScreen(),
    ),

    // Lawyer Dashboard Screen
    GoRoute(
      path: '/lawyer-dashboard',
      name: 'lawyer-dashboard',
      builder: (context, state) => const LawyerDashboardScreen(),
    ),

    // Lawyer Verification Upload Screen
    GoRoute(
      path: '/lawyer-verification',
      name: 'lawyer-verification',
      builder: (context, state) => const VerificationScreen(),
    ),

    // Lawyer Pending Approval Screen
    GoRoute(
      path: '/lawyer-verification-pending',
      name: 'lawyer-verification-pending',
      builder: (context, state) => const PendingApprovalScreen(),
    ),

    // Job Details Screen
    GoRoute(
      path: '/job-details/:jobId',
      name: 'job-details',
      builder: (context, state) {
        final job = state.extra as JobOpportunity;
        return JobDetailsScreen(job: job);
      },
    ),

    // Login Screen
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        // Extract role from query parameters
        final role = state.uri.queryParameters['role'] ?? 'client';
        return LoginScreen(role: role);
      },
    ),

    // Lawyer Search Screen
    GoRoute(
      path: '/lawyer-search',
      name: 'lawyer-search',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'];
        return LawyerSearchScreen(category: category);
      },
    ),

    // Lawyer Profile Screen
    GoRoute(
      path: '/lawyer-profile/:lawyerId',
      name: 'client-lawyer-profile',
      builder: (context, state) {
        final lawyerId = state.pathParameters['lawyerId']!;
        return client_lawyer.LawyerProfileScreen(lawyerId: lawyerId);
      },
    ),

    // Wallet Screen
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => const WalletScreen(),
    ),

    // Booking Screen
    GoRoute(
      path: '/booking/:lawyerId',
      name: 'booking',
      builder: (context, state) {
        final lawyerId = state.pathParameters['lawyerId']!;
        return BookingScreen(lawyerId: lawyerId);
      },
    ),

    // Booking Summary Screen
    GoRoute(
      path: '/booking-summary',
      name: 'booking-summary',
      builder: (context, state) {
        final bookingData = state.extra as Map<String, dynamic>;
        // Add lawyer name to booking data
        final lawyerId = bookingData['lawyerId'] as String;
        final lawyer = LawyerMockData.getLawyerById(lawyerId);
        bookingData['lawyerName'] = lawyer?.name ?? 'Unknown';

        return BookingSummaryScreen(bookingData: bookingData);
      },
    ),

    // Create Case Screen
    GoRoute(
      path: '/create-case',
      name: 'create-case',
      builder: (context, state) => const CreateCaseScreen(),
    ),

    // Chat Screen
    GoRoute(
      path: '/chat/:conversationId',
      name: 'chat',
      builder: (context, state) {
        final conversationId = state.pathParameters['conversationId']!;
        final lawyerData = state.extra as Map<String, dynamic>;
        return ChatScreen(
          conversationId: conversationId,
          lawyerData: lawyerData,
        );
      },
    ),

    // Edit Profile Screen
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),

    // Case Details Screen
    GoRoute(
      path: '/case-details/:caseId',
      name: 'case-details',
      builder: (context, state) {
        final caseId = state.pathParameters['caseId']!;
        final tab = state.uri.queryParameters['tab'];
        final initialTabIndex =
            tab == 'documents' ? 2 : (tab == 'timeline' ? 1 : 0);
        return CaseDetailsScreen(
          caseId: caseId,
          initialTabIndex: initialTabIndex,
        );
      },
    ),

    // Notifications Screen
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Saved Lawyers Screen
    GoRoute(
      path: '/saved-lawyers',
      name: 'saved-lawyers',
      builder: (context, state) => const SavedLawyersScreen(),
    ),

    // Profile Settings Routes
    GoRoute(
      path: '/security-settings',
      builder: (context, state) => const SecuritySettingsScreen(),
    ),
    GoRoute(
      path: '/language-settings',
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsPrivacyScreen(),
    ),

    // Lawyer Main Shell with Bottom Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return LawyerMainWrapper(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/lawyer-home',
              name: 'lawyer-home',
              builder: (context, state) => const LawyerHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/lawyer-cases',
              name: 'lawyer-cases',
              builder: (context, state) => const LawyerCasesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/lawyer-job-board',
              name: 'lawyer-job-board',
              builder: (context, state) => const JobBoardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/lawyer-profile',
              name: 'lawyer-portal-profile',
              builder: (context, state) =>
                  const portal_lawyer.LawyerProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Client Main Shell with Bottom Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ClientMainWrapper(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client-home',
              name: 'client-home',
              builder: (context, state) => const ClientHomeScreen(),
            ),
          ],
        ),

        // Branch 2: My Cases
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client-cases',
              name: 'client-cases',
              builder: (context, state) => const MyCasesScreen(),
            ),
          ],
        ),

        // Branch 3: Messages
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client-messages',
              name: 'client-messages',
              builder: (context, state) => const ConversationsScreen(),
            ),
          ],
        ),

        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/client-profile',
              name: 'client-profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
