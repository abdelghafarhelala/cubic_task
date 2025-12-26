import 'package:geolocator/geolocator.dart';

import '../../data/models/branch_atm_model.dart';

/// Parameters for the isolate function
class LocationFilteringParams {
  final double userLat;
  final double userLng;
  final List<Map<String, dynamic>> locationsJson;
  final int maxResults;
  final bool activeOnly;

  LocationFilteringParams({
    required this.userLat,
    required this.userLng,
    required this.locationsJson,
    required this.maxResults,
    required this.activeOnly,
  });
}

/// Isolate function to filter and calculate nearest locations in the background
///
/// **Performance Optimization for 60fps:**
/// This function runs in a separate isolate, completely offloading
/// distance calculations and filtering from the main UI thread.
///
/// Heavy operations performed in background:
/// - Filtering locations by active status
/// - Calculating distances for all locations (using Geolocator.distanceBetween)
/// - Sorting by distance
/// - Selecting top N results
///
/// This ensures smooth 60fps performance even with large datasets,
/// as the main UI thread remains free for rendering and user interactions.
List<Map<String, dynamic>> findNearestLocationsInIsolate(
    LocationFilteringParams params) {
  try {
    final locations = params.locationsJson.map((json) {
      return BranchAtmModel.fromJson(json);
    }).toList();

    final filteredLocations = params.activeOnly
        ? locations.where((loc) => loc.isActive).toList()
        : locations;

    final locationsWithDistance = filteredLocations.map((location) {
      final distance = Geolocator.distanceBetween(
        params.userLat,
        params.userLng,
        location.lat,
        location.lng,
      );
      return MapEntry(distance, location);
    }).toList();

    locationsWithDistance.sort((a, b) => a.key.compareTo(b.key));

    return locationsWithDistance
        .take(params.maxResults)
        .map((entry) => entry.value.toJson())
        .toList();
  } catch (e) {
    throw Exception('Failed to filter locations: ${e.toString()}');
  }
}
