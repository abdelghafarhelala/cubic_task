import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../data/repositories/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository favoritesRepository;
  final ConnectivityService connectivityService;
  String? _currentUserId;
  StreamSubscription<List<String>>? _favoritesSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  FavoritesCubit({
    FavoritesRepository? favoritesRepository,
    ConnectivityService? connectivityService,
  })  : favoritesRepository = favoritesRepository ?? getIt<FavoritesRepository>(),
        connectivityService = connectivityService ?? getIt<ConnectivityService>(),
        super(const FavoritesState()) {
    _initialize();
  }

  void _initialize() {
  }

  /// Set current user ID and load favorites
  Future<void> setUserId(String userId) async {
    _currentUserId = userId;
    await loadFavorites();
    
    await _startWatchingFavorites(userId);
    _startConnectivityListener();
  }

  /// Start watching favorites with connectivity check
  Future<void> _startWatchingFavorites(String userId) async {
    await _cancelFavoritesSubscription();
    
    final isOnline = await connectivityService.isOnline();
    if (!isOnline) {
      return;
    }

    try {
      _favoritesSubscription = favoritesRepository.watchFavorites(userId).listen(
        (favorites) {
          if (!isClosed) {
            emit(state.copyWith(
              favoriteBranchIds: favorites,
              status: FavoritesStatus.loaded,
              clearError: true,
            ));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(state.copyWith(
              status: FavoritesStatus.error,
              errorMessage: 'Failed to watch favorites: ${error.toString()}',
            ));
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Silently handle stream errors - local cache is available
    }
  }

  /// Cancel favorites subscription
  Future<void> _cancelFavoritesSubscription() async {
    await _favoritesSubscription?.cancel();
    _favoritesSubscription = null;
  }

  /// Listen for connectivity changes and sync when coming online
  void _startConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = connectivityService.onConnectivityChanged.listen(
      (connectivity) async {
        if (connectivity != ConnectivityResult.none && _currentUserId != null) {
          // Coming online - sync local changes to Firestore
          await favoritesRepository.syncFavorites(_currentUserId!);
          await loadFavorites();
          
          // Restart watching favorites
          await _startWatchingFavorites(_currentUserId!);
        } else {
          // Going offline - cancel stream
          await _cancelFavoritesSubscription();
        }
      },
    );
  }

  @override
  Future<void> close() {
    _cancelFavoritesSubscription();
    _connectivitySubscription?.cancel();
    return super.close();
  }

  /// Load favorites (offline-first)
  Future<void> loadFavorites() async {
    if (_currentUserId == null) return;

    emit(state.copyWith(status: FavoritesStatus.loading, clearError: true));
    try {
      final favorites = await favoritesRepository.getFavoriteBranchIds(_currentUserId!);
      emit(state.copyWith(
        status: FavoritesStatus.loaded,
        favoriteBranchIds: favorites,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: 'Failed to load favorites: ${e.toString()}',
      ));
    }
  }

  /// Toggle favorite status (add or remove)
  Future<void> toggleFavorite(String branchId) async {
    if (_currentUserId == null) return;

    final isCurrentlyFavorite = state.isFavorite(branchId);
    
    final updatedFavorites = List<String>.from(state.favoriteBranchIds);
    if (isCurrentlyFavorite) {
      updatedFavorites.remove(branchId);
    } else {
      updatedFavorites.add(branchId);
    }
    
    emit(state.copyWith(favoriteBranchIds: updatedFavorites));

    try {
      if (isCurrentlyFavorite) {
        await favoritesRepository.removeFavorite(_currentUserId!, branchId);
      } else {
        await favoritesRepository.addFavorite(_currentUserId!, branchId);
      }
      
      await favoritesRepository.syncFavorites(_currentUserId!);
    } catch (e) {
      emit(state.copyWith(favoriteBranchIds: state.favoriteBranchIds));
      emit(state.copyWith(
        errorMessage: 'Failed to ${isCurrentlyFavorite ? 'remove' : 'add'} favorite: ${e.toString()}',
      ));
    }
  }

  /// Sync favorites with Firestore
  Future<void> syncFavorites() async {
    if (_currentUserId == null) return;

    try {
      await favoritesRepository.syncFavorites(_currentUserId!);
      await loadFavorites();
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to sync favorites: ${e.toString()}',
      ));
    }
  }

  /// Check if a branch is favorite
  bool isFavorite(String branchId) {
    return state.isFavorite(branchId);
  }
}

