import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/network/dio_helper.dart';
import 'core/security/biometric_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/screens/auth/biometric_setup_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dio
  DioHelper.init();

  // Setup Service Locator
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getIt.blocProviders,
      child: MaterialApp(
        title: 'Secure Banking Branch Locator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == AuthStatus.authenticated) {
          // Check if user needs to set up biometric
          return const BiometricCheckScreen();
        }

        // Show login screen for unauthenticated users
        return const LoginScreen();
      },
    );
  }
}

class BiometricCheckScreen extends StatefulWidget {
  const BiometricCheckScreen({super.key});

  @override
  State<BiometricCheckScreen> createState() => _BiometricCheckScreenState();
}

class _BiometricCheckScreenState extends State<BiometricCheckScreen> {
  bool _isChecking = true;
  bool _needsSetup = false;
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    _checkBiometricSetup();
  }

  Future<void> _checkBiometricSetup() async {
    try {
      // Check if biometric is already enabled
      final isEnabled = await _biometricService.isBiometricEnabled();

      if (isEnabled) {
        // Biometric is already set up, go directly to dashboard
        if (mounted) {
          setState(() {
            _isChecking = false;
            _needsSetup = false;
          });
        }
        return;
      }

      // Biometric is not enabled, check if it's available on the device
      final isAvailable = await _biometricService.isBiometricAvailable();

      if (mounted) {
        setState(() {
          _isChecking = false;
          // Show setup screen only if biometric is available
          // If not available, go directly to dashboard (user can't set it up)
          _needsSetup = isAvailable;
        });
      }
    } catch (e) {
      // On error, go directly to dashboard
      if (mounted) {
        setState(() {
          _isChecking = false;
          _needsSetup = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_needsSetup) {
      return const BiometricSetupScreen();
    }

    return const DashboardScreen();
  }
}
