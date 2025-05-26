import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Theme configuration for the MIT Mobile app
/// This acts like a global CSS system for centralized UI management
class ThemeConfig {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color darkTeal = Color(0xFF0F766E);
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0x88ef4444);
  static const Color infoBlue = Color(0xFF3B82F6);
  
  // Neutral Colors
  static const Color darkGray = Color(0xFF1F2937);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFF9CA3AF);
  static const Color paleGray = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  
  // Surface Colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2A2A2A);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Light mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // New: for dark mode
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Border & Divider Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 10,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 15,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // Spacing
  static const double spaceXSmall = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceXLarge = 32.0;  static const double spaceXXLarge = 48.0;

  // Typography Scale
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    inherit: true,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
    inherit: true,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    inherit: true,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    inherit: true,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    inherit: true,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.3,
    inherit: true,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.2,
    inherit: true,
  );

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  /// Creates the light theme for the app
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: accentTeal,
      surface: surfaceLight,
      background: white,
      error: errorRed,
      onPrimary: white,
      onSecondary: white,
      onSurface: textPrimary,
      onBackground: textPrimary,
      onError: white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceLight,
      
      // Typography
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: textPrimary, inherit: true),
        displayMedium: displayMedium.copyWith(color: textPrimary, inherit: true),
        displaySmall: displaySmall.copyWith(color: textPrimary, inherit: true),
        headlineLarge: headlineLarge.copyWith(color: textPrimary, inherit: true),
        headlineMedium: headlineMedium.copyWith(color: textPrimary, inherit: true),
        headlineSmall: headlineSmall.copyWith(color: textPrimary, inherit: true),
        titleLarge: titleLarge.copyWith(color: textPrimary, inherit: true),
        titleMedium: titleMedium.copyWith(color: textPrimary, inherit: true),
        titleSmall: titleSmall.copyWith(color: textPrimary, inherit: true),
        bodyLarge: bodyLarge.copyWith(color: textPrimary, inherit: true),
        bodyMedium: bodyMedium.copyWith(color: textSecondary, inherit: true),
        bodySmall: bodySmall.copyWith(color: textSecondary, inherit: true),
        labelLarge: labelLarge.copyWith(color: textPrimary, inherit: true),
        labelMedium: labelMedium.copyWith(color: textSecondary, inherit: true),
        labelSmall: labelSmall.copyWith(color: textMuted, inherit: true),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: primaryBlue,
        foregroundColor: white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: headlineMedium.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
          inherit: true,
        ),
        iconTheme: const IconThemeData(color: white),
        actionsIconTheme: const IconThemeData(color: white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(radiusMedium),
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: cardLight,
        margin: const EdgeInsets.symmetric(vertical: spaceSmall),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceMedium,
            vertical: spaceSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentTeal,
        foregroundColor: white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceMedium,
        ),
        filled: true,
        fillColor: white,
        hintStyle: bodyMedium.copyWith(color: textMuted, inherit: true),
        labelStyle: bodyMedium.copyWith(color: textSecondary, inherit: true),
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: labelSmall.copyWith(fontWeight: FontWeight.w600, inherit: true),
        unselectedLabelStyle: labelSmall.copyWith(inherit: true),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue,
        unselectedLabelColor: textMuted,
        labelStyle: labelMedium.copyWith(fontWeight: FontWeight.w600, inherit: true),
        unselectedLabelStyle: labelMedium.copyWith(inherit: true),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryBlue, width: 3),
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerLight,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: paleGray,
        deleteIconColor: textMuted,
        disabledColor: borderLight,
        selectedColor: lightBlue,
        secondarySelectedColor: lightBlue,
        labelStyle: labelMedium,
        secondaryLabelStyle: labelMedium.copyWith(color: white, inherit: true),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: spaceSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: paleGray,
        circularTrackColor: paleGray,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkGray,
        contentTextStyle: bodyMedium.copyWith(color: white, inherit: true),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: headlineSmall.copyWith(color: textPrimary, inherit: true),
        contentTextStyle: bodyMedium.copyWith(color: textSecondary, inherit: true),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: lightBlue.withOpacity(0.1),
        titleTextStyle: titleMedium.copyWith(color: textPrimary, inherit: true),
        subtitleTextStyle: bodySmall.copyWith(color: textPrimary, inherit: true),
        leadingAndTrailingTextStyle: labelMedium.copyWith(color: textPrimary, inherit: true),
      ),
    );
  }

  /// Creates the dark theme for the app
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: lightBlue,
      brightness: Brightness.dark,
      primary: lightBlue,
      secondary: accentTeal,
      surface: surfaceDark,
      background: const Color(0xFF121212),
      error: errorRed,
      onPrimary: darkGray,
      onSecondary: darkGray,
      onSurface: textLight,
      onBackground: textLight,
      onError: darkGray,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surfaceDark,
      
      // Typography (Dark Mode)
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: textLight, inherit: true),
        displayMedium: displayMedium.copyWith(color: textLight, inherit: true),
        displaySmall: displaySmall.copyWith(color: textLight, inherit: true),
        headlineLarge: headlineLarge.copyWith(color: textLight, inherit: true),
        headlineMedium: headlineMedium.copyWith(color: textLight, inherit: true),
        headlineSmall: headlineSmall.copyWith(color: textLight, inherit: true),
        titleLarge: titleLarge.copyWith(color: textLight, inherit: true),
        titleMedium: titleMedium.copyWith(color: textLight, inherit: true),
        titleSmall: titleSmall.copyWith(color: textLight, inherit: true),
        bodyLarge: bodyLarge.copyWith(color: textLight, inherit: true),
        bodyMedium: bodyMedium.copyWith(color: lightGray, inherit: true),
        bodySmall: bodySmall.copyWith(color: lightGray, inherit: true),
        labelLarge: labelLarge.copyWith(color: textLight, inherit: true),
        labelMedium: labelMedium.copyWith(color: lightGray, inherit: true),
        labelSmall: labelSmall.copyWith(color: mediumGray, inherit: true),
      ),

      // AppBar Theme (Dark Mode)
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: cardDark,
        foregroundColor: textLight,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: headlineMedium.copyWith(
          color: textLight,
          fontWeight: FontWeight.w600,
          inherit: true,
        ),
        iconTheme: const IconThemeData(color: textLight),
        actionsIconTheme: const IconThemeData(color: textLight),
      ),

      // Card Theme (Dark Mode)
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: cardDark,
        margin: const EdgeInsets.symmetric(vertical: spaceSmall),
      ),

      // Elevated Button Theme (Dark Mode)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: darkGray,
          elevation: 2,
          shadowColor: lightBlue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme (Dark Mode)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightBlue,
          side: const BorderSide(color: lightBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme (Dark Mode)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceMedium,
            vertical: spaceSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button Theme (Dark Mode)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentTeal,
        foregroundColor: white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),

      // Input Decoration Theme (Dark Mode)
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: lightBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceMedium,
        ),
        filled: true,
        fillColor: cardDark,
        hintStyle: bodyMedium.copyWith(color: textMuted, inherit: true),
        labelStyle: bodyMedium.copyWith(color: textSecondary, inherit: true),
      ),

      // Bottom Navigation Theme (Dark Mode)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: lightBlue,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: labelSmall.copyWith(fontWeight: FontWeight.w600, inherit: true),
        unselectedLabelStyle: labelSmall.copyWith(inherit: true),
      ),

      // Tab Bar Theme (Dark Mode)
      tabBarTheme: TabBarTheme(
        labelColor: lightBlue,
        unselectedLabelColor: textMuted,
        labelStyle: labelMedium.copyWith(fontWeight: FontWeight.w600, inherit: true),
        unselectedLabelStyle: labelMedium.copyWith(inherit: true),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: lightBlue, width: 3),
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerDark,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        deleteIconColor: textMuted,
        disabledColor: borderDark,
        selectedColor: lightBlue,
        secondarySelectedColor: lightBlue,
        labelStyle: labelMedium,
        secondaryLabelStyle: labelMedium.copyWith(color: white, inherit: true),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: spaceSmall),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: paleGray,
        circularTrackColor: paleGray,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkGray,
        contentTextStyle: bodyMedium.copyWith(color: white, inherit: true),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: headlineSmall.copyWith(color: textLight, inherit: true),
        contentTextStyle: bodyMedium.copyWith(color: lightGray, inherit: true),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: lightBlue.withOpacity(0.1),
        titleTextStyle: titleMedium.copyWith(color: textPrimaryDark, inherit: true),
        subtitleTextStyle: bodySmall.copyWith(color: lightGray, inherit: true),
        leadingAndTrailingTextStyle: labelMedium.copyWith(color: lightGray, inherit: true),
      ),
    );
  }

  /// Utility method to get status colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return warningOrange;
      case 'approved':
        return successGreen;
      case 'rejected':
        return errorRed;
      case 'completed':
        return infoBlue;
      default:
        return mediumGray;
    }
  }

  /// Utility method to get role colors
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'administrator':
        return errorRed;
      case 'staff':
        return accentTeal;
      case 'student':
        return primaryBlue;
      default:
        return mediumGray;
    }
  }
  /// Utility method to create custom gradients
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)], // Light gray to soft blue-gray
  );

  static LinearGradient get accentGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentTeal, darkTeal],
  );

  /// Alternative gradients for sections that need more color
  static LinearGradient get softBlueGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDEF7FF), Color(0xFFBEE3F8)], // Very light blue tones
  );

  static LinearGradient get headerGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, Color(0xFF2563EB)], // Keep blue for specific sections that need it
  );

  /// Utility method for custom shadows
  static List<BoxShadow> customShadow({
    Color? color,
    double blur = 10,
    Offset offset = const Offset(0, 2),
    double spread = 0,
  }) {
    return [
      BoxShadow(
        color: color ?? Colors.black.withOpacity(0.1),
        blurRadius: blur,
        offset: offset,
        spreadRadius: spread,
      ),
    ];
  }
}
