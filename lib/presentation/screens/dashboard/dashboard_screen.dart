import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/custom_elevated_button.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/security/biometric_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/map/map_cubit.dart';
import '../../widgets/account_card.dart';
import '../../widgets/credit_card_widget.dart';
import '../../widgets/recent_transactions.dart';
import '../../widgets/transactions/transaction_data_generator.dart';
import '../../widgets/transactions/transaction_model.dart';
import '../map/map_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BiometricService _biometricService = BiometricService();
  String? _accountNumber;
  double? _balance;
  String? _cardNumber;
  String? _cardHolder;
  String? _expiryDate;
  String? _cardType;
  List<Transaction>? _transactions;

  @override
  void initState() {
    super.initState();
    _generateMockData();
    _checkBiometricOnLaunch();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadLocations();
    });
  }

  /// Preloads locations from API in background isolate
  /// This runs in a separate thread/isolate, not blocking the main UI thread
  /// Data will be ready when user navigates to map screen
  ///
  /// **Optimization**: Called after first frame is rendered to ensure fast startup
  void _preloadLocations() {
    final mapCubit = getIt<MapCubit>();
    mapCubit.loadLocations();
  }

  void _generateMockData() {
    setState(() {
      _accountNumber = AccountDataGenerator.generateAccountNumber();
      _balance = AccountDataGenerator.generateBalance();
      _cardNumber = CreditCardDataGenerator.generateCardNumber();
      _cardHolder = CreditCardDataGenerator.generateCardHolder();
      _expiryDate = CreditCardDataGenerator.generateExpiryDate();
      _cardType = CreditCardDataGenerator.generateCardType();
      _transactions =
          TransactionDataGenerator.generateMockTransactions(count: 5);
    });
  }

  Future<void> _checkBiometricOnLaunch() async {
    final isEnabled = await _biometricService.isBiometricEnabled();
    if (isEnabled) {
      final authenticated = await _biometricService.authenticate();
      if (!authenticated && mounted) {
        context.read<AuthCubit>().signOut();
      }
    }
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _generateMockData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppTheme.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_accountNumber != null && _balance != null)
                      AccountCard(
                        accountNumber: _accountNumber!,
                        balance: _balance!,
                      ),
                    const SizedBox(height: AppTheme.spacingLG),
                    if (_cardNumber != null &&
                        _cardHolder != null &&
                        _expiryDate != null &&
                        _cardType != null)
                      CreditCardWidget(
                        cardNumber: _cardNumber!,
                        cardHolder: _cardHolder!,
                        expiryDate: _expiryDate!,
                        cardType: _cardType!,
                      ),
                    const SizedBox(height: AppTheme.spacingLG),
                    if (_transactions != null)
                      RecentTransactions(transactions: _transactions!),
                    const SizedBox(height: AppTheme.spacingXL),
                    const SizedBox(height: AppTheme.spacingLG),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomElevatedButton(
              onPressed: _navigateToMap,
              text: 'Find Nearest Branches',
              icon: Icons.location_on,
            ),
          ),
        ],
      ),
    );
  }
}
