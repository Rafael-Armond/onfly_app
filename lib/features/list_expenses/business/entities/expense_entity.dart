import '../../data/models/expense_model.dart';

class ExpenseEntity extends Expense {
  String? id;
  double? amount;
  String? collectionName;
  String? created;
  String? description;
  String? expenseDate;
  String? latitude;
  String? longitude;
  String? updated;
  bool? persisted;

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

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['description'] = description;
    data['expense_date'] = expenseDate;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  @override
  ExpenseEntity.fromJson(Map<String, dynamic>? json,
      {bool isPersisted = true}) {
    amount = double.parse(json!['amount'].toString());
    collectionName = json['collectionName'];
    created = json['created'];
    description = json['description'];
    expenseDate = isPersisted ? json['expense_date'] : json['expenseDate'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    updated = json['updated'];
    persisted = isPersisted;
  }
}
