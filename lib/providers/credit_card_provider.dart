import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/credit_card_model.dart';
import '../services/database_service.dart';

class CreditCardProvider extends ChangeNotifier {
  Box<CreditCardModel>? _creditCardBox;
  CreditCardModel? _creditCard;

  CreditCardProvider() {
    _init();
  }

  void _init() {
    try {
      _creditCardBox = DatabaseService.getCreditCardBox();
      _loadCreditCard();
    } catch (e) {
      debugPrint('Error initializing CreditCardProvider: $e');
    }
  }

  CreditCardModel get creditCard {
    if (_creditCard == null) {
      _creditCard = CreditCardModel(
        creditLimit: 10000.0,
        soaDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 30)),
      );
      _saveCreditCard();
    }
    return _creditCard!;
  }

  void _loadCreditCard() {
    if (_creditCardBox == null) return;
    
    if (_creditCardBox!.isNotEmpty) {
      _creditCard = _creditCardBox!.getAt(0);
      debugPrint('Loaded credit card: Limit ${_creditCard?.creditLimit}');
    }
    notifyListeners();
  }

  Future<void> _saveCreditCard() async {
    if (_creditCardBox == null || _creditCard == null) return;
    
    if (_creditCardBox!.isEmpty) {
      await _creditCardBox!.add(_creditCard!);
    } else {
      await _creditCardBox!.putAt(0, _creditCard!);
    }
    debugPrint('Saved credit card: Limit ${_creditCard?.creditLimit}');
  }

  Future<void> updateCreditLimit(double limit) async {
    _creditCard = creditCard.copyWith(creditLimit: limit);
    await _saveCreditCard();
    notifyListeners();
  }

  Future<void> updateSoaDate(DateTime date) async {
    _creditCard = creditCard.copyWith(soaDate: date);
    await _saveCreditCard();
    notifyListeners();
  }

  Future<void> updateDueDate(DateTime date) async {
    _creditCard = creditCard.copyWith(dueDate: date);
    await _saveCreditCard();
    notifyListeners();
  }

  int get daysRemaining {
    final now = DateTime.now();
    final difference = creditCard.dueDate.difference(now).inDays;
    return difference;
  }

  bool get isOverdue => daysRemaining < 0;
}
