import 'package:hive/hive.dart';

part 'credit_card_model.g.dart';

@HiveType(typeId: 1)
class CreditCardModel extends HiveObject {
  @HiveField(0)
  double creditLimit;

  @HiveField(1)
  DateTime soaDate;

  @HiveField(2)
  DateTime dueDate;

  CreditCardModel({
    required this.creditLimit,
    required this.soaDate,
    required this.dueDate,
  });

  CreditCardModel copyWith({
    double? creditLimit,
    DateTime? soaDate,
    DateTime? dueDate,
  }) {
    return CreditCardModel(
      creditLimit: creditLimit ?? this.creditLimit,
      soaDate: soaDate ?? this.soaDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
