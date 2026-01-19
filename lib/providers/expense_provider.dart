import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../services/database_service.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<ExpenseModel> _expenseBox;
  List<ExpenseModel> _expenses = [];

  ExpenseProvider() {
    _expenseBox = DatabaseService.getExpenseBox();
    _loadExpenses();
  }

  List<ExpenseModel> get expenses => _expenses;

  List<ExpenseModel> get unpaidExpenses =>
      _expenses.where((e) => !e.isPaid).toList();

  List<ExpenseModel> get paidExpenses =>
      _expenses.where((e) => e.isPaid).toList();

  double get totalUnpaidAmount {
    return unpaidExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _loadExpenses() {
    _expenses = _expenseBox.values.toList();
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await _expenseBox.put(expense.id, expense);
    _loadExpenses();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _expenseBox.put(expense.id, expense);
    _loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
    _loadExpenses();
  }

  Future<void> togglePaidStatus(String id) async {
    final expense = _expenseBox.get(id);
    if (expense != null) {
      final updated = expense.copyWith(isPaid: !expense.isPaid);
      await _expenseBox.put(id, updated);
      _loadExpenses();
    }
  }
}
