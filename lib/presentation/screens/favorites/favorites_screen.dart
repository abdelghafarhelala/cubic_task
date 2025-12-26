import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/location_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/favorites/favorites_cubit.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../bloc/map/map_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favoritesState) {
          // Get all locations from MapCubit
          final mapState = context.watch<MapCubit>().state;
          final allLocations = mapState.allLocations;

          // Filter locations to show only favorites
          final favoriteLocations = allLocations
              .where((location) =>
                  favoritesState.favoriteBranchIds.contains(location.id))
              .toList();

          // Get user position for distance calculation
          final userPosition = mapState.userPosition;

          if (favoritesState.status == FavoritesStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoritesState.status == FavoritesStatus.error &&
              favoritesState.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.secondaryRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    favoritesState.errorMessage!,
                    style: AppTheme.bodyText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesCubit>().loadFavorites();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (favoriteLocations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: AppTheme.heading2.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any location\nto add it to your favorites',
                    style: AppTheme.bodyText.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<FavoritesCubit>().loadFavorites();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              itemCount: favoriteLocations.length,
              itemBuilder: (context, index) {
                final location = favoriteLocations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacingMD),
                  child: LocationCard(
                    location: location,
                    userPosition: userPosition,
                    showFavoriteButton: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

