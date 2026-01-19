import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _buyerController;
  late DateTime _selectedDate;
  late bool _isPaid;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _amountController = TextEditingController(
      text: widget.expense?.amount.toString() ?? '',
    );
    _buyerController = TextEditingController(
      text: widget.expense?.buyer ?? '',
    );
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _isPaid = widget.expense?.isPaid ?? false;
    _paymentMethod = widget.expense?.paymentMethod;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _buyerController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      
      final expense = ExpenseModel(
        id: widget.expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        buyer: _buyerController.text.trim(),
        date: _selectedDate,
        isPaid: _isPaid,
        paymentMethod: _isPaid ? _paymentMethod : null, // Only save payment method if paid
      );

      if (widget.expense == null) {
        expenseProvider.addExpense(expense);
      } else {
        expenseProvider.updateExpense(expense);
      }

      Navigator.pop(context);
    }
  }

  void _deleteExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
              expenseProvider.deleteExpense(widget.expense!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: widget.expense != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteExpense,
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description *',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'e.g., Grocery Shopping',
                  filled: true,
                  fillColor: const Color(0xFF1D1E33),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Amount *',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value.trim()) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Buyer *',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _buyerController,
                decoration: InputDecoration(
                  hintText: 'e.g., Juan Dela Cruz',
                  filled: true,
                  fillColor: const Color(0xFF1D1E33),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter buyer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Purchase Date',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('MMM dd, yyyy').format(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Payment Status',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isPaid ? 'Paid' : 'Unpaid',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _isPaid,
                      onChanged: (value) {
                        setState(() {
                          _isPaid = value;
                          if (!value) {
                            _paymentMethod = null; // Clear payment method if unpaid
                          }
                        });
                      },
                      activeTrackColor: Colors.green,
                    ),
                  ],
                ),
              ),
              if (_isPaid) ...[
                const SizedBox(height: 24),
                Text(
                  'Paid Via',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _paymentMethod,
                      isExpanded: true,
                      hint: Text(
                        'Select Payment Method',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      dropdownColor: const Color(0xFF1D1E33),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'BPI',
                          child: Text(
                            'BPI',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'GCASH',
                          child: Text(
                            'GCash',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'MAYA',
                          child: Text(
                            'Maya',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'CASH',
                          child: Text(
                            'Cash',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'OTHER',
                          child: Text(
                            'Other',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.expense == null ? 'Add Expense' : 'Update Expense',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
