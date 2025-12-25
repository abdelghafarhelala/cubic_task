import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// Placeholder for Map Screen - will be implemented in Phase 2
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Branches'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: AppTheme.spacingLG),
            Text(
              'Map Screen',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            Text(
              'This will be implemented in Phase 2',
              style: AppTheme.bodyTextSmall,
            ),
          ],
        ),
      ),
    );
  }
}





