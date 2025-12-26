import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/branch_atm_model.dart';
import '../../../screens/favorites/favorites_screen.dart';
import '../nearest_locations_list_screen.dart';

class MapFloatingActionButtons extends StatelessWidget {
  final List<BranchAtmModel> nearestLocations;
  final Position? userPosition;

  const MapFloatingActionButtons({
    super.key,
    required this.nearestLocations,
    this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16,
          left: 16,
          child: FloatingActionButton(
            heroTag: 'favorites_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            backgroundColor: AppTheme.secondaryRed,
            tooltip: 'View Favorites',
            shape: const CircleBorder(),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
        ),
        if (nearestLocations.isNotEmpty && userPosition != null)
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'nearest_locations_fab',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearestLocationsListScreen(
                      locations: nearestLocations,
                      userPosition: userPosition,
                    ),
                  ),
                );
              },
              backgroundColor: AppTheme.primaryBlue,
              tooltip: 'View Nearest Locations List',
              shape: const CircleBorder(),
              child: const Icon(
                Icons.list,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
