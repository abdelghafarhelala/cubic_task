import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'transactions/transaction_model.dart';
import 'transactions/transaction_item.dart';
import 'transactions/recent_transactions_header.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecentTransactionsHeader(),
        const SizedBox(height: AppTheme.spacingMD),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return TransactionItem(transaction: transactions[index]);
          },
        ),
      ],
    );
  }
}
