import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState()) {
    _checkAuthState();
  }

  void _checkAuthState() {
    authRepository.authStateChanges.listen((User? user) {
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: UserModel.fromFirebaseUser(user),
          clearError: true,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ));
      }
    });
  }

  Future<void> signUp(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await authRepository.signUp(email, password);
      print('user: $user');
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      ));
    } on AuthFailure catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
        clearUser: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
        clearUser: true,
      ));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await authRepository.signIn(email, password);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      ));
    } on AuthFailure catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
        clearUser: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
        clearUser: true,
      ));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await authRepository.signOut();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ));
    } on AuthFailure catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }
}
