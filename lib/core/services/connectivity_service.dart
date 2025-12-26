import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is currently online
  Future<bool> isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      // If we can't determine connectivity, assume offline for safety
      return false;
    }
  }

  /// Get current connectivity status
  Future<ConnectivityResult> getConnectivityStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      // Return first result or none if empty
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      // Return first result or none if empty
      return results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
  }
}

