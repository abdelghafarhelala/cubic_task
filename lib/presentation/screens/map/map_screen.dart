import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_theme.dart';
import '../../bloc/map/map_cubit.dart';
import '../../bloc/map/map_state.dart';
import 'widgets/location_page_view.dart';
import 'widgets/map_app_bar.dart';
import 'widgets/map_floating_action_buttons.dart';
import 'widgets/map_loading_indicator.dart';
import 'widgets/map_view.dart';
import 'widgets/offline_indicator_banner.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  late PageController _locationsPageController;
  LatLng? _center;
  bool _isMapReady = false;
  Position? _pendingUserLocation;
  int _currentLocationIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MapCubit>().getUserLocation();
    _locationsPageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _locationsPageController.dispose();
    super.dispose();
  }

  /// Handle page changes to update map view when user scrolls to different location
  void _onPageChanged(int index) {
    if (!mounted) return;

    final state = context.read<MapCubit>().state;
    if (state.nearestLocations.isEmpty) return;

    if (index != _currentLocationIndex &&
        index >= 0 &&
        index < state.nearestLocations.length) {
      setState(() {
        _currentLocationIndex = index;
      });
      _updateMapToLocation(index);
    }
  }

  /// Update map view to center on the location at the given index
  void _updateMapToLocation(int index) {
    final state = context.read<MapCubit>().state;
    final locations = state.nearestLocations;

    if (index >= 0 && index < locations.length && _isMapReady) {
      final location = locations[index];
      final latLng = LatLng(location.lat, location.lng);

      _mapController.move(latLng, 15.0);
      setState(() {
        _center = latLng;
      });
    }
  }

  void _moveToUserLocation(Position? position) {
    if (position != null && _isMapReady) {
      final latLng = LatLng(position.latitude, position.longitude);
      _mapController.move(latLng, 15.0);
      setState(() {
        _center = latLng;
      });
    } else if (position != null && !_isMapReady) {
      _pendingUserLocation = position;
    }
  }

  void _onMapReady() {
    setState(() {
      _isMapReady = true;
    });
    if (_pendingUserLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveToUserLocation(_pendingUserLocation);
        _pendingUserLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MapAppBar(),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if (state.userPosition != null && _center == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _moveToUserLocation(state.userPosition);
              }
            });
          }
          if (state.status == MapStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppTheme.secondaryRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == MapStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // CRITICAL: Prevent flash of 1000 markers - only show all locations if not getting user location or calculating nearest
          final bool canShowAllLocations = state.userPosition == null &&
              !state.isGettingUserLocation &&
              !state.isCalculatingNearest &&
              state.status == MapStatus.loaded &&
              state.allLocations.isNotEmpty;

          final locationsToShow =
              state.userPosition != null && state.nearestLocations.isNotEmpty
                  ? state.nearestLocations
                  : (canShowAllLocations ? state.allLocations : []);

          final center = state.userPosition != null
              ? LatLng(
                  state.userPosition!.latitude, state.userPosition!.longitude)
              : (locationsToShow.isNotEmpty
                  ? LatLng(locationsToShow.first.lat, locationsToShow.first.lng)
                  : const LatLng(30.0444, 31.2357));

          return Stack(
            children: [
              const OfflineIndicatorBanner(),
              MapView(
                mapController: _mapController,
                center: center,
                onMapReady: _onMapReady,
                locationsToShow: locationsToShow.cast(),
                userPosition: state.userPosition,
                isCalculatingNearest: state.isCalculatingNearest,
              ),
              if (state.userPosition != null &&
                  state.nearestLocations.isNotEmpty &&
                  !state.isGettingUserLocation &&
                  !state.isCalculatingNearest)
                LocationPageView(
                  pageController: _locationsPageController,
                  locations: state.nearestLocations,
                  userPosition: state.userPosition,
                  onPageChanged: _onPageChanged,
                  onLocationTap: (index) {
                    _updateMapToLocation(index);
                    _locationsPageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              else if (state.userPosition != null &&
                  (state.isGettingUserLocation ||
                      state.isCalculatingNearest ||
                      state.nearestLocations.isEmpty))
                const MapLoadingIndicator(),
              MapFloatingActionButtons(
                nearestLocations: state.nearestLocations,
                userPosition: state.userPosition,
              ),
            ],
          );
        },
      ),
    );
  }
}
