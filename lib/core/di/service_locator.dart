import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/services/connectivity_service.dart';
import '../../core/services/location_service.dart';
import '../../data/datasources/local/favorites_local_data_source.dart';
import '../../data/datasources/local/location_local_data_source.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/datasources/remote/favorites_remote_data_source.dart';
import '../../data/datasources/remote/location_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/favorites/favorites_cubit.dart';
import '../../presentation/bloc/map/map_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services - Register as singletons
  getIt.registerLazySingleton<LocationService>(
    () => LocationService(),
  );

  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );

  // Data Sources - Register as singletons
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
    ),
  );

  getIt.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(),
  );

  // Repositories - Register as singletons
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      remoteDataSource: getIt<LocationRemoteDataSource>(),
      localDataSource: getIt<LocationLocalDataSource>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      remoteDataSource: getIt<FavoritesRemoteDataSource>(),
      localDataSource: getIt<FavoritesLocalDataSource>(),
      connectivityService: getIt<ConnectivityService>(),
    ),
  );

  // Bloc/Cubit - Register as factories (new instance each time)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
    ),
  );

  // MapCubit as singleton so it persists across screens and can preload data
  getIt.registerLazySingleton<MapCubit>(
    () => MapCubit(
      locationRepository: getIt<LocationRepository>(),
      locationService: getIt<LocationService>(),
    ),
  );

  // FavoritesCubit as singleton to persist favorites state
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(),
  );
}

// Helper extension for BlocProvider
extension ServiceLocatorExtension on GetIt {
  List<BlocProvider> get blocProviders => [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider<MapCubit>(
          create: (_) => getIt<MapCubit>(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => getIt<FavoritesCubit>(),
        ),
      ];
}
