# MIT Mobile App

A Flutter application for MIT's mobile platform, providing different interfaces for students, staff, and administrators.

## Features

- Authentication system with role-based access
- Staff dashboard for managing letter templates and requests
- Administrator interface for user management and audit logs
- Student/Alumni portal for submitting and tracking requests

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / Xcode for mobile development
- VS Code (recommended) or Android Studio for development

### Setup

1. Clone the repository:
```bash
git clone https://github.com/your-org/mit-mobile.git
cd mit-mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Environment Setup

Create a `.env` file in the root directory with the following variables:
```
API_BASE_URL=your_api_base_url
```

### Flavor Configuration

The app uses Flutter flavors for different environments. Configure them in:

- Android: `android/app/build.gradle`
- iOS: `ios/Runner.xcworkspace`

## Architecture

- **State Management**: Riverpod
- **Routing**: GoRouter
- **Networking**: Dio with Retrofit
- **Local Storage**: SharedPreferences & Hive
- **Code Generation**: Freezed, JSON Serializable

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests
4. Submit a pull request

## License

This project is proprietary and confidential.
