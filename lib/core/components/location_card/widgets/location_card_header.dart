import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/branch_atm_model.dart';

class LocationCardHeader extends StatelessWidget {
  final BranchAtmModel location;

  const LocationCardHeader({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: location.isActive
                ? (location.isBranch
                    ? AppTheme.secondaryGreen.withValues(alpha: 0.1)
                    : AppTheme.primaryBlue.withValues(alpha: 0.1))
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            location.isBranch ? Icons.account_balance : Icons.atm,
            color: location.isActive
                ? (location.isBranch
                    ? AppTheme.secondaryGreen
                    : AppTheme.primaryBlue)
                : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: AppTheme.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: location.isBranch
                          ? AppTheme.secondaryGreen.withValues(alpha: 0.1)
                          : AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      location.type,
                      style: AppTheme.bodyTextSmall.copyWith(
                        color: location.isBranch
                            ? AppTheme.secondaryGreen
                            : AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!location.isActive) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Inactive',
                        style: AppTheme.bodyTextSmall.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

