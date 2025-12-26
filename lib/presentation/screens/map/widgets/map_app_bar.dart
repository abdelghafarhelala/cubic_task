import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../presentation/bloc/map/map_cubit.dart';
import '../../../../presentation/bloc/map/map_state.dart';

class MapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Find Branches & ATMs'),
      actions: [
        BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon(
                state.showOnlyActive
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
              ),
              onPressed: () {
                context.read<MapCubit>().toggleActiveFilter();
              },
              tooltip: state.showOnlyActive
                  ? 'Show All Locations'
                  : 'Show Active Only',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<MapCubit>().refreshLocations();
          },
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

