import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../constants/app_constants.dart';

/// Encrypted SQLite Database Helper
///
/// Uses SQLCipher for encryption at rest
/// Database is encrypted with a key stored in secure storage
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// Get or create encrypted database instance
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize encrypted database
  Future<Database> _initDatabase() async {
    final dbPath = await _getDatabasePath();
    final encryptionKey = await _getOrCreateEncryptionKey();

    return await openDatabase(
      dbPath,
      version: AppConstants.databaseVersion,
      password: encryptionKey,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Get database file path
  Future<String> _getDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);
    return path;
  }

  /// Get or create encryption key from secure storage
  Future<String> _getOrCreateEncryptionKey() async {
    String? key = await _secureStorage.read(key: AppConstants.encryptionKeyKey);

    if (key == null || key.isEmpty) {
      key = _generateEncryptionKey();
      await _secureStorage.write(
          key: AppConstants.encryptionKeyKey, value: key);
    }

    return key;
  }

  /// Generate a cryptographically secure random encryption key
  ///
  /// Uses Random.secure() which provides cryptographically secure random numbers
  /// suitable for generating encryption keys. Generates 32 random bytes
  /// (256 bits) and converts to hex string (64 characters) as required by SQLCipher.
  String _generateEncryptionKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE branches_atms (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        address TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        services TEXT,
        phone TEXT,
        working_hours TEXT,
        cached_at INTEGER NOT NULL,
        UNIQUE(id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_type ON branches_atms(type)
    ''');

    await db.execute('''
      CREATE INDEX idx_is_active ON branches_atms(is_active)
    ''');

    await db.execute('''
      CREATE INDEX idx_cached_at ON branches_atms(cached_at)
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        branch_id TEXT PRIMARY KEY,
        added_at INTEGER NOT NULL,
        UNIQUE(branch_id)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_added_at ON favorites(added_at)
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites (
            branch_id TEXT PRIMARY KEY,
            added_at INTEGER NOT NULL,
            UNIQUE(branch_id)
          )
        ''');

        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_added_at ON favorites(added_at)
        ''');
      }
    }
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }

  /// Clear all cached data (useful for testing or reset)
  Future<void> clearCache() async {
    final db = await database;
    await db.delete('branches_atms');
  }
}
