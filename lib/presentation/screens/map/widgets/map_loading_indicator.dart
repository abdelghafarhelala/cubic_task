import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MapLoadingIndicator extends StatelessWidget {
  const MapLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

