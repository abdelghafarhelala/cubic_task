import 'dart:convert';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/errors/failures.dart';
import '../../models/branch_atm_model.dart';

abstract class LocationLocalDataSource {
  /// Cache branches and ATMs locally
  Future<void> cacheBranchesAndAtms(List<BranchAtmModel> locations);
  
  /// Get cached branches and ATMs
  Future<List<BranchAtmModel>> getCachedBranchesAndAtms();
  
  /// Get cache timestamp
  Future<DateTime?> getCacheTimestamp();
  
  /// Clear cached data
  Future<void> clearCache();
  
  /// Check if cache exists and is valid
  Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 24)});
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  // Lazy initialization - database only created when first accessed
  DatabaseHelper? _dbHelper;
  DatabaseHelper get _db => _dbHelper ??= DatabaseHelper();

  @override
  Future<void> cacheBranchesAndAtms(List<BranchAtmModel> locations) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      // Clear old data
      await db.delete('branches_atms');

      // Insert new data
      for (final location in locations) {
        batch.insert(
          'branches_atms',
          {
            'id': location.id,
            'name': location.name,
            'type': location.type,
            'address': location.address,
            'lat': location.lat,
            'lng': location.lng,
            'is_active': location.isActive ? 1 : 0,
            'services': jsonEncode(location.services),
            'phone': location.phone,
            'working_hours': location.workingHours,
            'cached_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheFailure('Failed to cache locations: ${e.toString()}');
    }
  }

  @override
  Future<List<BranchAtmModel>> getCachedBranchesAndAtms() async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'branches_atms',
        orderBy: 'cached_at DESC',
      );

      return maps.map((map) {
        return BranchAtmModel(
          id: map['id'] as String,
          name: map['name'] as String,
          type: map['type'] as String,
          address: map['address'] as String,
          lat: map['lat'] as double,
          lng: map['lng'] as double,
          isActive: (map['is_active'] as int) == 1,
          services: map['services'] != null
              ? List<String>.from(jsonDecode(map['services'] as String))
              : [],
          phone: map['phone'] as String?,
          workingHours: map['working_hours'] as String? ?? '',
        );
      }).toList();
    } catch (e) {
      throw CacheFailure('Failed to get cached locations: ${e.toString()}');
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final db = await _db.database;
      final result = await db.query(
        'branches_atms',
        columns: ['cached_at'],
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      final timestamp = result.first['cached_at'] as int?;
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _db.clearCache();
    } catch (e) {
      throw CacheFailure('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 24)}) async {
    try {
      final timestamp = await getCacheTimestamp();
      if (timestamp == null) {
        return false;
      }

      final age = DateTime.now().difference(timestamp);
      return age < maxAge;
    } catch (e) {
      return false;
    }
  }
}

