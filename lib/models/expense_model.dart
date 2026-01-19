import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String buyer;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  bool isPaid;

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.buyer,
    required this.date,
    this.isPaid = false,
  });

  ExpenseModel copyWith({
    String? id,
    String? description,
    double? amount,
    String? buyer,
    DateTime? date,
    bool? isPaid,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      buyer: buyer ?? this.buyer,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
