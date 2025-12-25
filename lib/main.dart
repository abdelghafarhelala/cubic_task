import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/biometric_setup_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Dio
  DioHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: ServiceLocator.blocProviders,
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

  @override
  void initState() {
    super.initState();
    _checkBiometricSetup();
  }

  Future<void> _checkBiometricSetup() async {
    // This is a simplified check - in a real app, you'd check if this is the first login
    // For now, we'll always show the setup screen on first authentication
    // In production, you'd store a flag in Firestore or local storage
    
    // Simulate a check - you can modify this logic
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _isChecking = false;
        _needsSetup = true; // Set to true to show setup, false to go directly to dashboard
      });
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
