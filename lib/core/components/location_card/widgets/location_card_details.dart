import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/branch_atm_model.dart';

class LocationCardDetails extends StatelessWidget {
  final BranchAtmModel location;

  const LocationCardDetails({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    if (location.workingHours.isEmpty && location.phone == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (location.workingHours.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location.workingHours,
                  style: AppTheme.bodyTextSmall.copyWith(
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        if (location.phone != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                location.phone!,
                style: AppTheme.bodyTextSmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

