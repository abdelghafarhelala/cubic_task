import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../../../core/errors/failures.dart';

abstract class FavoritesLocalDataSource {
  Future<List<String>> getFavoriteBranchIds();
  Future<void> addFavorite(String branchId);
  Future<void> removeFavorite(String branchId);
  Future<bool> isFavorite(String branchId);
  Future<void> syncFavorites(List<String> branchIds);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  // Lazy initialization - database only created when first accessed
  DatabaseHelper? _dbHelper;
  DatabaseHelper get _db => _dbHelper ??= DatabaseHelper();

  @override
  Future<List<String>> getFavoriteBranchIds() async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'favorites',
        columns: ['branch_id'],
        orderBy: 'added_at DESC',
      );

      return maps.map((map) => map['branch_id'] as String).toList();
    } catch (e) {
      throw CacheFailure('Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> addFavorite(String branchId) async {
    try {
      final db = await _db.database;
      await db.insert(
        'favorites',
        {
          'branch_id': branchId,
          'added_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheFailure('Failed to add favorite: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFavorite(String branchId) async {
    try {
      final db = await _db.database;
      await db.delete(
        'favorites',
        where: 'branch_id = ?',
        whereArgs: [branchId],
      );
    } catch (e) {
      throw CacheFailure('Failed to remove favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String branchId) async {
    try {
      final db = await _db.database;
      final result = await db.query(
        'favorites',
        columns: ['branch_id'],
        where: 'branch_id = ?',
        whereArgs: [branchId],
        limit: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncFavorites(List<String> branchIds) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      // Clear old favorites
      await db.delete('favorites');

      // Insert synced favorites
      for (final branchId in branchIds) {
        batch.insert(
          'favorites',
          {
            'branch_id': branchId,
            'added_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheFailure('Failed to sync favorites: ${e.toString()}');
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      final db = await _db.database;
      await db.delete('favorites');
    } catch (e) {
      throw CacheFailure('Failed to clear favorites: ${e.toString()}');
    }
  }
}

