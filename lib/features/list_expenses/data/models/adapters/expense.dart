import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense {
  Expense({
    required this.amount,
    required this.description,
    required this.expenseDate,
    required this.latitude,
    required this.longitude,
  });

  @HiveField(0)
  double amount;

  @HiveField(1)
  String description;

  @HiveField(2)
  String expenseDate;

  @HiveField(3)
  String latitude;

  @HiveField(4)
  String longitude;
}
