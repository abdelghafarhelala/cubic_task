import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart' as credit_card;
import '../../core/theme/app_theme.dart';
import 'dart:math';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardType; // 'Visa' or 'Mastercard'

  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardType,
  });

  credit_card.CardType _getCardType() {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return credit_card.CardType.visa;
      case 'mastercard':
        return credit_card.CardType.mastercard;
      default:
        return credit_card.CardType.visa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return credit_card.CreditCardWidget(
      cardNumber: cardNumber.replaceAll(' ', ''),
      expiryDate: expiryDate,
      cardHolderName: cardHolder,
      cvvCode: '123',
      showBackView: false,
      obscureCardNumber: false,
      obscureCardCvv: true,
      isHolderNameVisible: true,
      cardBgColor: AppTheme.primaryBlue,
      textStyle: AppTheme.bodyText.copyWith(
        color: AppTheme.textLight,
      ),
      cardType: _getCardType(),
      animationDuration: const Duration(milliseconds: 1000),
      onCreditCardWidgetChange: (credit_card.CreditCardBrand brand) {},
    );
  }
}

// Helper function to generate random credit card data
class CreditCardDataGenerator {
  static String generateCardNumber() {
    final random = Random();
    final part1 = (random.nextInt(9000) + 1000).toString();
    final part2 = (random.nextInt(9000) + 1000).toString();
    final part3 = (random.nextInt(9000) + 1000).toString();
    final part4 = (random.nextInt(9000) + 1000).toString();
    return '$part1 $part2 $part3 $part4';
  }

  static String generateExpiryDate() {
    final random = Random();
    final month = (random.nextInt(12) + 1).toString().padLeft(2, '0');
    final year = (2025 + random.nextInt(5)).toString().substring(2);
    return '$month/$year';
  }

  static String generateCardHolder() {
    final names = [
      'John Doe',
      'Jane Smith',
      'Robert Johnson',
      'Emily Davis',
      'Michael Brown',
    ];
    final random = Random();
    return names[random.nextInt(names.length)];
  }

  static String generateCardType() {
    final random = Random();
    return random.nextBool() ? 'Visa' : 'Mastercard';
  }
}
