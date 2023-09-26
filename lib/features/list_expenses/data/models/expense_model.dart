// ignore_for_file: must_be_immutable

class Expense {
  int? page;
  int? perPage;
  int? totalItems;
  int? totalPages;
  List<Items>? items;

  Expense(
      {this.page, this.perPage, this.totalItems, this.totalPages, this.items});

  Expense.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['perPage'] = perPage;
    data['totalItems'] = totalItems;
    data['totalPages'] = totalPages;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  double? amount;
  String? collectionId;
  String? collectionName;
  String? created;
  String? description;
  String? expenseDate;
  String? id;
  String? latitude;
  String? longitude;
  String? updated;

  Items(
      {this.amount,
      this.collectionId,
      this.collectionName,
      this.created,
      this.description,
      this.expenseDate,
      this.id,
      this.latitude,
      this.longitude,
      this.updated});

  Items.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    collectionId = json['collectionId'];
    collectionName = json['collectionName'];
    created = json['created'];
    description = json['description'];
    expenseDate = json['expense_date'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = amount;
    data['collectionId'] = collectionId;
    data['collectionName'] = collectionName;
    data['created'] = created;
    data['description'] = description;
    data['expense_date'] = expenseDate;
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['updated'] = updated;
    return data;
  }
}
