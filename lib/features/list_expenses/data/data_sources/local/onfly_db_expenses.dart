import 'package:onfly_app/core/error/failure.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';

import '../../../../../config/hive/boxes/expense_box.dart';
import '../../models/adapters/expense.dart';

abstract class IOnflyDBService {
  Future<ExpenseEntity> saveExpenseLocaly(ExpenseEntity expenseEntity);
  List<ExpenseEntity> getExpensesLocaly();
  Future<void> removeExpenseLocaly(String id);
}

class OnflyDBService implements IOnflyDBService {
  Map<String, dynamic> toJson(Expense expense) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = expense.description;
    data['amount'] = expense.amount;
    data['expenseDate'] = expense.expenseDate;
    data['latitude'] = expense.latitude;
    data['longitude'] = expense.longitude;
    return data;
  }

  @override
  List<ExpenseEntity> getExpensesLocaly() {
    try {
      return expensesBox.values
          .map((dynamic item) =>
              ExpenseEntity.fromJson(toJson(item), isPersisted: false))
          .toList();
    } on Exception {
      throw Failure(
          message: "Não foi possível carregar as despesas localmente");
    }
  }

  @override
  Future<ExpenseEntity> saveExpenseLocaly(ExpenseEntity expenseEntity) async {
    try {
      final teste = Expense(
          description: expenseEntity.description!,
          amount: expenseEntity.amount!,
          expenseDate: expenseEntity.expenseDate!,
          latitude: expenseEntity.latitude!,
          longitude: expenseEntity.longitude!);
      await expensesBox.put('Key_${expenseEntity.description}', teste);
      return expenseEntity;
    } on Exception {
      throw Failure(message: "Não foi possível inserir a despesa localmente");
    }
  }

  @override
  Future<void> removeExpenseLocaly(String description) async {
    try {
      await expensesBox.delete(description);
    } on Exception {
      throw Exception("Não foi possível remover a despesa");
    }
  }
}
