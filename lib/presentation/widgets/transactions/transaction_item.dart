import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'shopping':
        return Icons.shopping_bag;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'bills':
        return Icons.receipt;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.payment;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'shopping':
        return Colors.purple;
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'bills':
        return Colors.red;
      case 'transfer':
        return Colors.green;
      default:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getCategoryColor(transaction.category).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        child: Icon(
          _getCategoryIcon(transaction.category),
          color: _getCategoryColor(transaction.category),
        ),
      ),
      title: Text(
        transaction.title,
        style: AppTheme.bodyText.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        dateFormatter.format(transaction.date),
        style: AppTheme.bodyTextSmall,
      ),
      trailing: Text(
        '${transaction.type == 'debit' ? '-' : '+'}${formatter.format(transaction.amount)}',
        style: AppTheme.bodyText.copyWith(
          fontWeight: FontWeight.bold,
          color: transaction.type == 'debit'
              ? AppTheme.secondaryRed
              : AppTheme.secondaryGreen,
        ),
      ),
    );
  }
}

