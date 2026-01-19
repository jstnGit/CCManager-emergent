import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../services/database_service.dart';

class ExpenseProvider extends ChangeNotifier {
  Box<ExpenseModel>? _expenseBox;
  List<ExpenseModel> _expenses = [];

  ExpenseProvider() {
    _init();
  }

  void _init() {
    try {
      _expenseBox = DatabaseService.getExpenseBox();
      _loadExpenses();
    } catch (e) {
      debugPrint('Error initializing ExpenseProvider: $e');
    }
  }

  List<ExpenseModel> get expenses => _expenses.where((e) => !e.isArchived).toList();

  List<ExpenseModel> get archivedExpenses => _expenses.where((e) => e.isArchived).toList();

  List<ExpenseModel> get unpaidExpenses =>
      expenses.where((e) => !e.isPaid).toList();

  List<ExpenseModel> get paidExpenses =>
      expenses.where((e) => e.isPaid).toList();

  // NEW: Both paid and unpaid count toward used credit
  double get totalUsedCredit {
    final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    debugPrint('Total used credit (paid + unpaid): $total');
    return total;
  }

  // Keep for backward compatibility
  double get totalUnpaidAmount {
    final total = unpaidExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    debugPrint('Total unpaid amount: $total');
    return total;
  }

  // Get total paid amount by payment method (excluding archived)
  Map<String, double> get paymentMethodTotals {
    final totals = <String, double>{};
    
    for (var expense in paidExpenses) {
      if (expense.paymentMethod != null) {
        final method = expense.paymentMethod!;
        totals[method] = (totals[method] ?? 0.0) + expense.amount;
      }
    }
    
    return totals;
  }

  // Pay credit card - archives all current expenses
  Future<void> payCreditCard() async {
    if (_expenseBox == null) return;
    
    final now = DateTime.now();
    debugPrint('Paying credit card - archiving ${expenses.length} expenses');
    
    for (var expense in expenses) {
      final archived = expense.copyWith(
        isArchived: true,
        archivedDate: now,
      );
      await _expenseBox!.put(expense.id, archived);
    }
    
    _loadExpenses();
  }

  // Get archived expenses by date range
  List<ExpenseModel> getArchivedByDateRange(DateTime start, DateTime end) {
    return archivedExpenses.where((e) {
      if (e.archivedDate == null) return false;
      return e.archivedDate!.isAfter(start.subtract(const Duration(days: 1))) &&
             e.archivedDate!.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  void _loadExpenses() {
    if (_expenseBox == null) return;
    
    _expenses = _expenseBox!.values.toList();
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    debugPrint('Loaded ${_expenses.length} expenses');
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    if (_expenseBox == null) return;
    
    debugPrint('Adding expense: ${expense.description}, Amount: ${expense.amount}, Paid: ${expense.isPaid}');
    await _expenseBox!.put(expense.id, expense);
    _loadExpenses();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    if (_expenseBox == null) return;
    
    debugPrint('Updating expense: ${expense.description}, Amount: ${expense.amount}, Paid: ${expense.isPaid}');
    await _expenseBox!.put(expense.id, expense);
    _loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    if (_expenseBox == null) return;
    
    debugPrint('Deleting expense: $id');
    await _expenseBox!.delete(id);
    _loadExpenses();
  }

  Future<void> togglePaidStatus(String id) async {
    if (_expenseBox == null) return;
    
    final expense = _expenseBox!.get(id);
    if (expense != null) {
      final updated = expense.copyWith(isPaid: !expense.isPaid);
      debugPrint('Toggling paid status for: ${expense.description}, New status: ${updated.isPaid}');
      await _expenseBox!.put(id, updated);
      _loadExpenses();
    }
  }
}
