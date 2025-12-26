import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<String>> getFavoriteBranchIds(String userId);
  Future<void> addFavorite(String userId, String branchId);
  Future<void> removeFavorite(String userId, String branchId);
  Future<bool> isFavorite(String userId, String branchId);
  Stream<List<String>> watchFavorites(String userId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  FavoritesRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Get user's favorite branch IDs from Firestore
  @override
  Future<List<String>> getFavoriteBranchIds(String userId) async {
    try {
      final doc = await firestore
          .collection(AppConstants.favoritesCollection)
          .doc(userId)
          .collection('branches')
          .get();

      return doc.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw NetworkFailure('Failed to get favorites: ${e.toString()}');
    }
  }

  /// Add a branch to user's favorites
  @override
  Future<void> addFavorite(String userId, String branchId) async {
    try {
      await firestore
          .collection(AppConstants.favoritesCollection)
          .doc(userId)
          .collection('branches')
          .doc(branchId)
          .set({
        'addedAt': FieldValue.serverTimestamp(),
        'branchId': branchId,
      });
    } catch (e) {
      throw NetworkFailure('Failed to add favorite: ${e.toString()}');
    }
  }

  /// Remove a branch from user's favorites
  @override
  Future<void> removeFavorite(String userId, String branchId) async {
    try {
      await firestore
          .collection(AppConstants.favoritesCollection)
          .doc(userId)
          .collection('branches')
          .doc(branchId)
          .delete();
    } catch (e) {
      throw NetworkFailure('Failed to remove favorite: ${e.toString()}');
    }
  }

  /// Check if a branch is in user's favorites
  @override
  Future<bool> isFavorite(String userId, String branchId) async {
    try {
      final doc = await firestore
          .collection(AppConstants.favoritesCollection)
          .doc(userId)
          .collection('branches')
          .doc(branchId)
          .get();

      return doc.exists;
    } catch (e) {
      throw NetworkFailure('Failed to check favorite: ${e.toString()}');
    }
  }

  /// Watch user's favorites in real-time
  @override
  Stream<List<String>> watchFavorites(String userId) {
    try {
      return firestore
          .collection(AppConstants.favoritesCollection)
          .doc(userId)
          .collection('branches')
          .snapshots()
          .handleError((error) {
        // Silently handle connection errors when offline
        return <String>[];
      }).map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
    } catch (e) {
      return Stream.value(<String>[]);
    }
  }
}
