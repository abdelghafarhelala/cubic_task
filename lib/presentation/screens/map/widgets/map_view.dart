import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/services/cached_network_tile_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/branch_atm_model.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final LatLng center;
  final VoidCallback onMapReady;
  final List<BranchAtmModel> locationsToShow;
  final Position? userPosition;
  final bool isCalculatingNearest;

  const MapView({
    super.key,
    required this.mapController,
    required this.center,
    required this.onMapReady,
    required this.locationsToShow,
    this.userPosition,
    required this.isCalculatingNearest,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 12.0,
        onMapReady: onMapReady,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.cubic_task',
          tileProvider: CachedNetworkTileProvider(),
          errorTileCallback: (tile, error, stackTrace) {
            return;
          },
          maxNativeZoom: 19,
          maxZoom: 19,
        ),
        if (userPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  userPosition!.latitude,
                  userPosition!.longitude,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
        if (locationsToShow.isNotEmpty)
          MarkerLayer(
            markers: locationsToShow.map((location) {
              return Marker(
                point: LatLng(location.lat, location.lng),
                width: 30,
                height: 30,
                child: Icon(
                  location.isBranch ? Icons.account_balance : Icons.atm,
                  color: location.isActive
                      ? AppTheme.secondaryGreen
                      : AppTheme.secondaryRed,
                  size: 30,
                ),
              );
            }).toList(),
          ),
        if (isCalculatingNearest)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

