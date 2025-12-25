import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../constants/app_constants.dart';

class BiometricService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  BiometricService({
    LocalAuthentication? localAuth,
    FlutterSecureStorage? secureStorage,
  })  : _localAuth = localAuth ?? LocalAuthentication(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: AppConstants.biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> enableBiometric() async {
    try {
      await _secureStorage.write(
        key: AppConstants.biometricEnabledKey,
        value: 'true',
      );
    } catch (e) {
      throw Exception('Failed to enable biometric: ${e.toString()}');
    }
  }

  Future<void> disableBiometric() async {
    try {
      await _secureStorage.delete(key: AppConstants.biometricEnabledKey);
    } catch (e) {
      throw Exception('Failed to disable biometric: ${e.toString()}');
    }
  }

  Future<bool> authenticate() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your banking app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithSetup() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Enable biometric authentication for quick access',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await enableBiometric();
      }

      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}





