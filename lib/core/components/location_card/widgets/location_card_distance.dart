import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class LocationCardDistance extends StatelessWidget {
  final double? distance;

  const LocationCardDistance({
    super.key,
    this.distance,
  });

  String _formatDistance(double? distance) {
    if (distance == null) return 'Distance unknown';
    if (distance < 1) {
      return '${(distance * 1000).toStringAsFixed(0)} m';
    }
    return '${distance.toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    if (distance == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.near_me,
            size: 16,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDistance(distance),
            style: AppTheme.bodyTextSmall.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

