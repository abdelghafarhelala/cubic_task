import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/branch_atm_model.dart';
import 'location_card/widgets/location_card_address.dart';
import 'location_card/widgets/location_card_details.dart';
import 'location_card/widgets/location_card_distance.dart';
import 'location_card/widgets/location_card_header.dart';
import 'location_card/widgets/location_favorite_button.dart';

/// Reusable location card component
///
/// Displays location information in a card format
/// Can be used in lists, horizontal scrolls, or as standalone items
class LocationCard extends StatelessWidget {
  final BranchAtmModel location;
  final Position? userPosition;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  const LocationCard({
    super.key,
    required this.location,
    this.userPosition,
    this.onTap,
    this.showFavoriteButton = true,
  });

  /// Calculate distance from user to location
  double? _calculateDistance() {
    if (userPosition == null) return null;
    return Geolocator.distanceBetween(
          userPosition!.latitude,
          userPosition!.longitude,
          location.lat,
          location.lng,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistance();
    // Use MediaQuery to make card width responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth - (AppTheme.spacingMD * 2); // Full width minus padding

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: LocationCardHeader(location: location),
                  ),
                  if (showFavoriteButton)
                    LocationFavoriteButton(locationId: location.id),
                ],
              ),
              const SizedBox(height: 12),
              LocationCardAddress(location: location),
              if (distance != null) ...[
                const SizedBox(height: 12),
                LocationCardDistance(distance: distance),
              ],
              if (location.workingHours.isNotEmpty ||
                  location.phone != null) ...[
                const SizedBox(height: 8),
                LocationCardDetails(location: location),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
