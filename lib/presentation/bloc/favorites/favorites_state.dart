import 'package:equatable/equatable.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<String> favoriteBranchIds;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favoriteBranchIds = const [],
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<String>? favoriteBranchIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favoriteBranchIds: favoriteBranchIds ?? this.favoriteBranchIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool isFavorite(String branchId) {
    return favoriteBranchIds.contains(branchId);
  }

  @override
  List<Object?> get props => [status, favoriteBranchIds, errorMessage];
}

