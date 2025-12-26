class AppConstants {
  // API
  static const String branchesAtmsUrl =
      'https://raw.githubusercontent.com/ahmed-hosni-1/location-cubic/refs/heads/main/branches_atms_10000.json';

  // Storage Keys
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String encryptionKeyKey = 'encryption_key';

  // Database
  static const String databaseName = 'banking_app.db';
  static const int databaseVersion = 2; // Updated to add favorites table
  static const Duration cacheMaxAge =
      Duration(hours: 24); // Cache validity period

  // Map
  static const int maxNearestLocations = 50;

  // Security
  static const String secureStorageKey = 'secure_storage';

  // Firebase Collections
  static const String favoritesCollection = 'favorites';
  static const String usersCollection = 'users';
}
