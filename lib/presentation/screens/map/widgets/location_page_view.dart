import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/components/location_card.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/branch_atm_model.dart';

class LocationPageView extends StatelessWidget {
  final PageController pageController;
  final List<BranchAtmModel> locations;
  final Position? userPosition;
  final Function(int) onPageChanged;
  final Function(int) onLocationTap;

  const LocationPageView({
    super.key,
    required this.pageController,
    required this.locations,
    this.userPosition,
    required this.onPageChanged,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 240,
        child: PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
              ),
              child: LocationCard(
                location: location,
                userPosition: userPosition,
                onTap: () => onLocationTap(index),
              ),
            );
          },
        ),
      ),
    );
  }
}

