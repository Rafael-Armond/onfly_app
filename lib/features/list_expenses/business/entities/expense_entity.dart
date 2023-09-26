import '../../data/models/expense_model.dart';

class ExpenseEntity extends Expense {
  final String? id;
  final double? amount;
  final String? collectionName;
  final String? created;
  final String? description;
  final String? expenseDate;
  final String? latitude;
  final String? longitude;
  final String? updated;
  final bool? persisted;

  ExpenseEntity({
    this.id,
    this.amount,
    this.collectionName,
    this.created,
    this.description,
    this.expenseDate,
    this.latitude,
    this.longitude,
    this.updated,
    this.persisted,
  });

  // @override
  // List<Object?> get props {
  //   return [
  //     amount,
  //     collectionName,
  //     created,
  //     description,
  //     expenseDate,
  //     latitude,
  //     longitude,
  //     updated,
  //   ];
  // }
}
