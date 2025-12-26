import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/failures.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp(String email, String password);
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      return await remoteDataSource.signUp(email, password);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      return await remoteDataSource.signIn(email, password);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;
}
