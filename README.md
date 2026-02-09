# Zakoota - Legal Services Marketplace

A Flutter-based legal services marketplace connecting clients with verified lawyers.

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/          # Theme configuration
│   ├── utils/          # Utility functions
│   └── widgets/        # Shared widgets
├── features/
│   ├── auth/           # Authentication
│   ├── cases/          # Case management
│   ├── chat/           # Messaging system
│   ├── dashboard/      # User dashboard
│   ├── documents/      # Document management
│   ├── lawyer_profile/ # Lawyer profiles
│   └── wallet/         # Payment & wallet
├── models/             # Data models
├── providers/          # State management
└── services/           # Backend services
```

## Tech Stack

- **Framework**: Flutter (Latest Stable)
- **Backend**: Firebase (Firestore, Auth, Storage, Cloud Functions)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive + Firestore Offline Persistence

## Design System

- **Primary**: Deep Navy Blue (#0F172A)
- **Secondary**: Premium Gold (#D4AF37)
- **Typography**: Poppins (Headings), Inter (Body)

## Getting Started

1. Install Flutter SDK
2. Run `flutter pub get`
3. Configure Firebase
4. Run `flutter run`
