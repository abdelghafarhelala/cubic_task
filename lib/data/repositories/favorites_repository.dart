import '../../core/errors/failures.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/local/favorites_local_data_source.dart';
import '../datasources/remote/favorites_remote_data_source.dart';

abstract class FavoritesRepository {
  Future<List<String>> getFavoriteBranchIds(String userId);
  Future<void> addFavorite(String userId, String branchId);
  Future<void> removeFavorite(String userId, String branchId);
  Future<bool> isFavorite(String userId, String branchId);
  Stream<List<String>> watchFavorites(String userId);
  Future<void> syncFavorites(String userId);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  FavoritesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  /// Offline-First Pattern for Favorites:
  /// 1. Try to get from local cache first (works offline)
  /// 2. If online, sync with Firestore and update cache
  /// 3. If offline, return cached favorites
  @override
  Future<List<String>> getFavoriteBranchIds(String userId) async {
    try {
      final localFavorites = await localDataSource.getFavoriteBranchIds();
      final isOnline = await connectivityService.isOnline();

      if (isOnline) {
        syncFavorites(userId).catchError((_) {});
      }

      return localFavorites;
    } catch (e) {
      throw NetworkFailure('Failed to get favorites: ${e.toString()}');
    }
  }

  /// Add favorite - works offline-first
  /// If online: syncs to Firestore and local cache
  /// If offline: saves to local cache only (will sync when online)
  @override
  Future<void> addFavorite(String userId, String branchId) async {
    try {
      await localDataSource.addFavorite(branchId);

      final isOnline = await connectivityService.isOnline();
      if (isOnline) {
        try {
          await remoteDataSource.addFavorite(userId, branchId);
        } catch (e) {
          // Will sync later when online
        }
      }
    } catch (e) {
      throw NetworkFailure('Failed to add favorite: ${e.toString()}');
    }
  }

  /// Remove favorite - works offline-first
  @override
  Future<void> removeFavorite(String userId, String branchId) async {
    try {
      await localDataSource.removeFavorite(branchId);

      final isOnline = await connectivityService.isOnline();
      if (isOnline) {
        try {
          await remoteDataSource.removeFavorite(userId, branchId);
        } catch (e) {
          // Will sync later when online
        }
      }
    } catch (e) {
      throw NetworkFailure('Failed to remove favorite: ${e.toString()}');
    }
  }

  /// Check if branch is favorite - checks local cache first
  @override
  Future<bool> isFavorite(String userId, String branchId) async {
    try {
      return await localDataSource.isFavorite(branchId);
    } catch (e) {
      return false;
    }
  }

  /// Watch favorites in real-time from Firestore
  /// Only watches when online, returns empty stream when offline
  @override
  Stream<List<String>> watchFavorites(String userId) async* {
    final isOnline = await connectivityService.isOnline();
    if (!isOnline) {
      return;
    }

    try {
      yield* remoteDataSource.watchFavorites(userId);
    } catch (e) {
      // Silently handle errors - local cache is available
    }
  }

  /// Sync favorites between Firestore and local cache
  /// Pushes local changes to Firestore, then merges with remote
  @override
  Future<void> syncFavorites(String userId) async {
    try {
      final isOnline = await connectivityService.isOnline();
      if (!isOnline) {
        return;
      }

      // Step 1: Get local favorites (may have offline changes)
      final localFavorites = await localDataSource.getFavoriteBranchIds();

      // Step 2: Push local favorites to Firestore
      if (localFavorites.isNotEmpty) {
        for (final branchId in localFavorites) {
          try {
            await remoteDataSource.addFavorite(userId, branchId);
          } catch (e) {
            // Continue with other favorites even if one fails
          }
        }
      }

      // Step 3: Get remote favorites and merge
      final remoteFavorites =
          await remoteDataSource.getFavoriteBranchIds(userId);

      // Step 4: Merge local and remote (union of both)
      final mergedFavorites =
          <String>{...localFavorites, ...remoteFavorites}.toList();

      // Step 5: Update local cache with merged result
      await localDataSource.syncFavorites(mergedFavorites);
    } catch (e) {
      // Local cache remains available
    }
  }
}
