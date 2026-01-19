import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense_model.dart';
import '../models/credit_card_model.dart';

class DatabaseService {
  static const String expenseBoxName = 'expenses';
  static const String creditCardBoxName = 'creditCard';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(ExpenseModelAdapter());
    Hive.registerAdapter(CreditCardModelAdapter());
    
    await Hive.openBox<ExpenseModel>(expenseBoxName);
    await Hive.openBox<CreditCardModel>(creditCardBoxName);
  }

  static Box<ExpenseModel> getExpenseBox() {
    return Hive.box<ExpenseModel>(expenseBoxName);
  }

  static Box<CreditCardModel> getCreditCardBox() {
    return Hive.box<CreditCardModel>(creditCardBoxName);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
