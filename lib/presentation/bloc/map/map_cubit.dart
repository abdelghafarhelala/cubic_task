import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/errors/failures.dart';
import '../../../core/services/location_service.dart';
import '../../../data/repositories/location_repository.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final LocationRepository locationRepository;
  final LocationService locationService;

  MapCubit({
    required this.locationRepository,
    required this.locationService,
  }) : super(const MapState());

  /// Loads locations using offline-first pattern
  ///
  /// **Phase 3: Offline-First Architecture**
  /// - Tries cache first (fast, works offline)
  /// - If online and cache stale, fetches from API and updates cache
  /// - If offline, returns cached data (even if stale)
  ///
  /// **Performance: 60fps Optimized**
  /// - Network request runs asynchronously (non-blocking)
  /// - JSON parsing happens in a background isolate (via repository)
  /// - UI remains smooth and responsive during data fetching
  ///
  /// **Usage:**
  /// This should be called when dashboard opens to preload data.
  /// The data will be ready when user navigates to map screen.
  Future<void> loadLocations() async {
    emit(state.copyWith(status: MapStatus.loading, clearError: true));
    try {
      // Repository implements offline-first: tries cache, then API if online
      final locations = await locationRepository.getBranchesAndAtms();
      
      emit(state.copyWith(
        status: MapStatus.loaded,
        allLocations: locations,
        isOffline: false,
        clearError: true,
      ));
    } on NetworkFailure catch (e) {
      final isOfflineError = e.message.contains('No internet') || 
                            e.message.contains('No cached data');
      
      if (isOfflineError && state.allLocations.isNotEmpty) {
        emit(state.copyWith(
          status: MapStatus.loaded,
          isOffline: true,
          errorMessage: 'Showing cached data (offline mode)',
        ));
      } else {
        emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: e.message,
          isOffline: isOfflineError,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Failed to load locations: ${e.toString()}',
      ));
    }
  }

  /// Force sync with remote API (pull-to-refresh)
  /// 
  /// If sync fails but cached data exists, shows warning instead of error
  Future<void> syncLocations() async {
    emit(state.copyWith(status: MapStatus.loading, clearError: true));
    try {
      await locationRepository.syncLocations();
      final locations = await locationRepository.getBranchesAndAtms();
      emit(state.copyWith(
        status: MapStatus.loaded,
        allLocations: locations,
        isOffline: false,
        clearError: true,
      ));
      
      if (state.userPosition != null) {
        await _findNearestLocations(state.userPosition!);
      }
    } on NetworkFailure catch (e) {
      if (state.allLocations.isNotEmpty) {
        emit(state.copyWith(
          status: MapStatus.loaded,
          isOffline: true,
          errorMessage: 'Sync failed: ${e.message}. Showing cached data.',
        ));
      } else {
        emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: e.message,
          isOffline: true,
        ));
      }
    } catch (e) {
      if (state.allLocations.isNotEmpty) {
        emit(state.copyWith(
          status: MapStatus.loaded,
          isOffline: true,
          errorMessage: 'Sync failed: ${e.toString()}. Showing cached data.',
        ));
      } else {
        emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: 'Failed to sync: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> getUserLocation() async {
    emit(state.copyWith(isGettingUserLocation: true, clearError: true));

    try {
      final position = await locationService.getCurrentLocation();
      emit(state.copyWith(
        userPosition: position,
        isGettingUserLocation: false,
        clearError: true,
      ));

      if (state.allLocations.isNotEmpty) {
        emit(state.copyWith(isCalculatingNearest: true));
        await _findNearestLocations(position);
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        if (state.allLocations.isNotEmpty) {
          emit(state.copyWith(isCalculatingNearest: true));
          await _findNearestLocations(position);
        }
      }
    } on LocationFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        isGettingUserLocation: false,
        isCalculatingNearest: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to get location: ${e.toString()}',
        isGettingUserLocation: false,
        isCalculatingNearest: false,
      ));
    }
  }

  Future<void> findNearestLocations() async {
    if (state.userPosition != null && state.allLocations.isNotEmpty) {
      await _findNearestLocations(state.userPosition!);
    }
  }

  /// Finds nearest locations using background isolate
  ///
  /// **Performance: 60fps Optimized**
  /// - Distance calculations run in a background isolate
  /// - Filtering and sorting happen off the main UI thread
  /// - UI remains smooth at 60fps during heavy computations
  /// - Even with 10,000+ locations, the main thread stays responsive
  Future<void> _findNearestLocations(Position userPosition) async {
    try {
      final nearest = await locationService.findNearestLocations(
        userPosition: userPosition,
        locations: state.allLocations,
        maxResults: 50,
        activeOnly: state.showOnlyActive,
      );

      emit(state.copyWith(
        nearestLocations: nearest,
        isCalculatingNearest: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to find nearest locations: ${e.toString()}',
        isCalculatingNearest: false,
      ));
    }
  }

  Future<void> toggleActiveFilter() async {
    final newValue = !state.showOnlyActive;
    emit(state.copyWith(showOnlyActive: newValue));

    if (state.userPosition != null) {
      emit(state.copyWith(isCalculatingNearest: true));
      await _findNearestLocations(state.userPosition!);
    }
  }

  void refreshLocations() {
    // Use sync to force refresh from API
    syncLocations();
  }
}
