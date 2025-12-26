import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../presentation/bloc/favorites/favorites_cubit.dart';
import '../../../../presentation/bloc/favorites/favorites_state.dart';

class LocationFavoriteButton extends StatelessWidget {
  final String locationId;

  const LocationFavoriteButton({
    super.key,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        final isFavorite = favoritesState.isFavorite(locationId);
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppTheme.secondaryRed : Colors.grey,
          ),
          onPressed: () {
            final cubit = context.read<FavoritesCubit>();
            cubit.toggleFavorite(locationId);
          },
          tooltip: isFavorite
              ? 'Remove from favorites'
              : 'Add to favorites',
        );
      },
    );
  }
}

