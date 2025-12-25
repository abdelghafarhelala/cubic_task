import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';

class ServiceLocator {
  // Data Sources
  static AuthRemoteDataSource get authRemoteDataSource {
    return AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
    );
  }

  // Repositories
  static AuthRepository get authRepository {
    return AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );
  }

  // Bloc Providers
  static List<BlocProvider> get blocProviders => [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            authRepository: authRepository,
          ),
        ),
      ];
}





