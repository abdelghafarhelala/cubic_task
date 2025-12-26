import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/security/biometric_service.dart';
import '../../../core/theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';
import 'widgets/biometric_setup_content.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isLoading = false;
  bool _isAvailable = false;
  String _biometricType = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final available = await _biometricService.isBiometricAvailable();
    if (available) {
      final types = await _biometricService.getAvailableBiometrics();
      setState(() {
        _isAvailable = true;
        if (types.contains(BiometricType.face)) {
          _biometricType = 'Face ID';
        } else if (types.contains(BiometricType.fingerprint)) {
          _biometricType = 'Fingerprint';
        } else {
          _biometricType = 'Biometric';
        }
      });
    } else {
      setState(() {
        _isAvailable = false;
      });
    }
  }

  Future<void> _enableBiometric() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _biometricService.authenticateWithSetup();
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else if (mounted) {
        // User cancelled the authentication dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric setup was cancelled'),
            backgroundColor: AppTheme.secondaryRed,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Show specific error message
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.secondaryRed,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _skipBiometric() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Setup'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLG),
          child: BiometricSetupContent(
            isAvailable: _isAvailable,
            biometricType: _biometricType,
            isLoading: _isLoading,
            onEnable: _enableBiometric,
            onSkip: _skipBiometric,
          ),
        ),
      ),
    );
  }
}
