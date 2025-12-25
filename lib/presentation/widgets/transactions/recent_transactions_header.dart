import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RecentTransactionsHeader extends StatelessWidget {
  final VoidCallback? onViewAll;

  const RecentTransactionsHeader({
    super.key,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: AppTheme.heading3,
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }
}

