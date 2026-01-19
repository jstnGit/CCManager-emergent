import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/credit_card_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _creditLimitController;

  @override
  void initState() {
    super.initState();
    final creditCardProvider = Provider.of<CreditCardProvider>(context, listen: false);
    _creditLimitController = TextEditingController(
      text: creditCardProvider.creditCard.creditLimit.toString(),
    );
  }

  @override
  void dispose() {
    _creditLimitController.dispose();
    super.dispose();
  }

  Future<void> _selectSoaDate(BuildContext context) async {
    final creditCardProvider = Provider.of<CreditCardProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: creditCardProvider.creditCard.soaDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      creditCardProvider.updateSoaDate(picked);
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final creditCardProvider = Provider.of<CreditCardProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: creditCardProvider.creditCard.dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      creditCardProvider.updateDueDate(picked);
    }
  }

  void _updateCreditLimit() {
    final value = double.tryParse(_creditLimitController.text.trim());
    if (value != null && value > 0) {
      final creditCardProvider = Provider.of<CreditCardProvider>(context, listen: false);
      creditCardProvider.updateCreditLimit(value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credit limit updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CreditCardProvider>(
        builder: (context, creditCardProvider, child) {
          final creditCard = creditCardProvider.creditCard;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Credit Card Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Credit Limit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _creditLimitController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('₱', style: TextStyle(fontSize: 18)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1D1E33),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _updateCreditLimit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Statement Date',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectSoaDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 16),
                          Text(
                            DateFormat('MMM dd, yyyy').format(creditCard.soaDate),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const Icon(Icons.edit, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Due Date',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDueDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 16),
                          Text(
                            DateFormat('MMM dd, yyyy').format(creditCard.dueDate),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const Icon(Icons.edit, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
