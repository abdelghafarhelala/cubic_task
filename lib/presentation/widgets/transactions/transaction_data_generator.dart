import 'dart:math';
import 'transaction_model.dart';

class TransactionDataGenerator {
  static List<Transaction> generateMockTransactions({int count = 5}) {
    final random = Random();
    final transactions = <Transaction>[];
    final categories = ['Shopping', 'Food', 'Transport', 'Bills', 'Transfer'];
    final titles = {
      'Shopping': ['Amazon Purchase', 'Target', 'Walmart', 'Best Buy'],
      'Food': ['Starbucks', 'McDonald\'s', 'Restaurant', 'Uber Eats'],
      'Transport': ['Uber Ride', 'Gas Station', 'Parking', 'Metro'],
      'Bills': ['Electric Bill', 'Water Bill', 'Internet', 'Phone Bill'],
      'Transfer': ['Bank Transfer', 'Venmo', 'PayPal', 'Zelle'],
    };

    for (int i = 0; i < count; i++) {
      final category = categories[random.nextInt(categories.length)];
      final categoryTitles = titles[category]!;
      final title = categoryTitles[random.nextInt(categoryTitles.length)];
      final type = random.nextBool() ? 'debit' : 'credit';
      final amount = (random.nextDouble() * 500) + 10;
      final date = DateTime.now().subtract(Duration(days: random.nextInt(30)));

      transactions.add(
        Transaction(
          id: 'trans_$i',
          title: title,
          amount: amount,
          date: date,
          type: type,
          category: category,
        ),
      );
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }
}

