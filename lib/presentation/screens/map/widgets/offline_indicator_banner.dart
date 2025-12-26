import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../presentation/bloc/map/map_cubit.dart';
import '../../../../presentation/bloc/map/map_state.dart';

class OfflineIndicatorBanner extends StatelessWidget {
  const OfflineIndicatorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      buildWhen: (previous, current) => previous.isOffline != current.isOffline,
      builder: (context, state) {
        if (!state.isOffline) return const SizedBox.shrink();

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppTheme.secondaryGold.withValues(alpha: 0.2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMD,
              vertical: AppTheme.spacingSM,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: AppTheme.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Offline Mode - Showing cached data',
                    style: AppTheme.bodyTextSmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<MapCubit>().syncLocations();
                  },
                  child: const Text(
                    'Sync',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

