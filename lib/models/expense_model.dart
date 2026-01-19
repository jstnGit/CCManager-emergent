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

  @HiveField(6)
  String? paymentMethod; // BPI, GCASH, MAYA, CASH, OTHER (removed CREDIT_CARD)

  @HiveField(7)
  bool isArchived; // Moved to history after credit card payment

  @HiveField(8)
  DateTime? archivedDate; // When it was moved to history

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.buyer,
    required this.date,
    this.isPaid = false,
    this.paymentMethod,
    this.isArchived = false,
    this.archivedDate,
  });

  ExpenseModel copyWith({
    String? id,
    String? description,
    double? amount,
    String? buyer,
    DateTime? date,
    bool? isPaid,
    String? paymentMethod,
    bool? isArchived,
    DateTime? archivedDate,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      buyer: buyer ?? this.buyer,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isArchived: isArchived ?? this.isArchived,
      archivedDate: archivedDate ?? this.archivedDate,
    );
  }
}
