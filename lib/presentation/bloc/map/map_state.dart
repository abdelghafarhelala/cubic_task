import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/models/branch_atm_model.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final List<BranchAtmModel> allLocations;
  final List<BranchAtmModel> nearestLocations;
  final Position? userPosition;
  final String? errorMessage;
  final bool showOnlyActive;
  final bool isCalculatingNearest;
  final bool isGettingUserLocation;
  final bool isOffline; // Phase 3: Offline mode indicator

  const MapState({
    this.status = MapStatus.initial,
    this.allLocations = const [],
    this.nearestLocations = const [],
    this.userPosition,
    this.errorMessage,
    this.showOnlyActive = true,
    this.isCalculatingNearest = false,
    this.isGettingUserLocation = false,
    this.isOffline = false,
  });

  MapState copyWith({
    MapStatus? status,
    List<BranchAtmModel>? allLocations,
    List<BranchAtmModel>? nearestLocations,
    Position? userPosition,
    String? errorMessage,
    bool? showOnlyActive,
    bool? isCalculatingNearest,
    bool? isGettingUserLocation,
    bool? isOffline,
    bool clearUserPosition = false,
    bool clearError = false,
  }) {
    return MapState(
      status: status ?? this.status,
      allLocations: allLocations ?? this.allLocations,
      nearestLocations: nearestLocations ?? this.nearestLocations,
      userPosition:
          clearUserPosition ? null : (userPosition ?? this.userPosition),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      showOnlyActive: showOnlyActive ?? this.showOnlyActive,
      isCalculatingNearest: isCalculatingNearest ?? this.isCalculatingNearest,
      isGettingUserLocation:
          isGettingUserLocation ?? this.isGettingUserLocation,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allLocations,
        nearestLocations,
        userPosition,
        errorMessage,
        showOnlyActive,
        isCalculatingNearest,
        isGettingUserLocation,
        isOffline,
      ];
}
