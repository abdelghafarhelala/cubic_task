import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/components/location_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/branch_atm_model.dart';

class NearestLocationsListScreen extends StatelessWidget {
  final List<BranchAtmModel> locations;
  final Position? userPosition;

  const NearestLocationsListScreen({
    super.key,
    required this.locations,
    this.userPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nearest Locations (${locations.length})',
          style: AppTheme.heading2.copyWith(
            color: AppTheme.textLight,
          ),
        ),
      ),
      body: locations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No locations found',
                    style: AppTheme.heading3.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              itemCount: locations.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spacingMD),
              itemBuilder: (context, index) {
                final location = locations[index];
                return LocationCard(
                  location: location,
                  userPosition: userPosition,
                  onTap: () {
                    // Could add navigation to location details or map pin
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${location.name} - ${location.address}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
