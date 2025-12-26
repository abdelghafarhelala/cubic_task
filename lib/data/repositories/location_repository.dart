import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/local/location_local_data_source.dart';
import '../datasources/remote/location_remote_data_source.dart';
import '../models/branch_atm_model.dart';

abstract class LocationRepository {
  Future<List<BranchAtmModel>> getBranchesAndAtms();
  Future<void> syncLocations(); // Force sync with remote
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  /// Offline-First Pattern:
  /// 1. Try to get data from cache first (fast, works offline)
  /// 2. If online and cache is stale/missing, fetch from API and update cache
  /// 3. If offline, return cached data (even if stale)
  @override
  Future<List<BranchAtmModel>> getBranchesAndAtms() async {
    try {
      final cachedData = await localDataSource.getCachedBranchesAndAtms();
      final isCacheValid = await localDataSource.isCacheValid(
        maxAge: AppConstants.cacheMaxAge,
      );
      final isOnline = await connectivityService.isOnline();

      if (cachedData.isNotEmpty && isCacheValid) {
        if (isOnline) {
          syncLocations().catchError((_) {});
        }
        return cachedData;
      }

      if (isOnline) {
        try {
          final remoteData = await remoteDataSource.getBranchesAndAtms();
          localDataSource.cacheBranchesAndAtms(remoteData);
          return remoteData;
        } on NetworkFailure {
          if (cachedData.isNotEmpty) {
            return cachedData;
          }
          rethrow;
        }
      }

      if (cachedData.isNotEmpty) {
        return cachedData;
      }

      throw const NetworkFailure(
        'No internet connection and no cached data available',
      );
    } on NetworkFailure {
      rethrow;
    } on CacheFailure {
      rethrow;
    } catch (e) {
      throw NetworkFailure('Failed to get locations: ${e.toString()}');
    }
  }

  /// Force sync with remote API and update cache
  /// Useful for pull-to-refresh or manual sync
  ///
  /// Throws NetworkFailure if offline or network error occurs
  @override
  Future<void> syncLocations() async {
    try {
      final isOnline = await connectivityService.isOnline();
      if (!isOnline) {
        throw const NetworkFailure('No internet connection');
      }

      final remoteData = await remoteDataSource.getBranchesAndAtms();
      await localDataSource.cacheBranchesAndAtms(remoteData);
    } on NetworkFailure {
      rethrow;
    } catch (e) {
      throw NetworkFailure('Failed to sync locations: ${e.toString()}');
    }
  }
}
