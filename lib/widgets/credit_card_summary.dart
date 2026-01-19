import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/credit_card_provider.dart';
import '../providers/expense_provider.dart';
import '../screens/settings_screen.dart';

class CreditCardSummary extends StatelessWidget {
  const CreditCardSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final creditCardProvider = Provider.of<CreditCardProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final creditCard = creditCardProvider.creditCard;
    final usedCredit = expenseProvider.totalUsedCredit; // Changed: both paid and unpaid
    final availableCredit = creditCard.creditLimit - usedCredit;
    final daysRemaining = creditCardProvider.daysRemaining;
    final isOverdue = creditCardProvider.isOverdue;

    debugPrint('=== CreditCardSummary Build ===');
    debugPrint('Credit Limit: ${creditCard.creditLimit}');
    debugPrint('Used Credit: $usedCredit');
    debugPrint('Available Credit: $availableCredit');
    debugPrint('Total Expenses: ${expenseProvider.expenses.length}');
    debugPrint('Unpaid Expenses: ${expenseProvider.unpaidExpenses.length}');

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit Card',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white70),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Credit Limit',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            '₱${NumberFormat('#,##0.00').format(creditCard.creditLimit)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: usedCredit / creditCard.creditLimit,
              minHeight: 8,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                usedCredit > creditCard.creditLimit
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                      '₱${NumberFormat('#,##0.00').format(usedCredit)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[400],
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    Text(
                      '₱${NumberFormat('#,##0.00').format(availableCredit)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[400],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2D47),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statement Date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(creditCard.soaDate),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2D47),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(creditCard.dueDate),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Pay Credit Card Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: expenseProvider.expenses.isEmpty
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Pay Credit Card'),
                          content: Text(
                            'Pay ₱${NumberFormat('#,##0.00').format(usedCredit)} and move all expenses to history?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Pay Now'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await expenseProvider.payCreditCard();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Paid ₱${NumberFormat('#,##0.00').format(usedCredit)} - Expenses moved to history',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.payment),
              label: const Text('Pay Credit Card'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isOverdue ? Colors.red[700] : Colors.green[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOverdue ? Icons.warning : Icons.access_time,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isOverdue
                      ? '${daysRemaining.abs()} days overdue'
                      : '$daysRemaining days remaining',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          // Payment Method Totals
          if (expenseProvider.paymentMethodTotals.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D47),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payments Made',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...expenseProvider.paymentMethodTotals.entries.map((entry) {
                    final methodName = entry.key == 'GCASH'
                            ? 'GCash'
                            : entry.key == 'MAYA'
                                ? 'Maya'
                                : entry.key == 'CASH'
                                    ? 'Cash'
                                    : entry.key == 'OTHER'
                                        ? 'Other'
                                        : entry.key;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getPaymentIcon(entry.key),
                                size: 16,
                                color: Colors.blue[300],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                methodName,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            '₱${NumberFormat('#,##0.00').format(entry.value)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.green[300],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'BPI':
        return Icons.account_balance;
      case 'GCASH':
      case 'MAYA':
        return Icons.phone_android;
      case 'CASH':
        return Icons.money;
      case 'OTHER':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }
}