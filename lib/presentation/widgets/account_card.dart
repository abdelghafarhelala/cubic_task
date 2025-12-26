import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import 'dart:math';

class AccountCard extends StatelessWidget {
  final String accountNumber;
  final double balance;

  const AccountCard({
    super.key,
    required this.accountNumber,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLG),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: AppTheme.cardShadowList,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Account Balance',
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.textLight.withValues(alpha: 0.9),
                ),
              ),
              Icon(
                Icons.account_balance,
                color: AppTheme.textLight.withValues(alpha: 0.9),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            formatter.format(balance),
            style: AppTheme.heading1.copyWith(
              color: AppTheme.textLight,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Row(
            children: [
              Text(
                'Account Number: ',
                style: AppTheme.bodyTextSmall.copyWith(
                  color: AppTheme.textLight.withValues(alpha: 0.8),
                ),
              ),
              Text(
                accountNumber,
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper function to generate random account data
class AccountDataGenerator {
  static String generateAccountNumber() {
    final random = Random();
    return '${random.nextInt(9000) + 1000}-${random.nextInt(9000) + 1000}-${random.nextInt(9000) + 1000}-${random.nextInt(9000) + 1000}';
  }

  static double generateBalance() {
    final random = Random();
    return (random.nextDouble() * 50000) + 1000; // Between 1000 and 51000
  }
}





