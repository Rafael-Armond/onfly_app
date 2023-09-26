import 'package:get/get.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';
import 'package:onfly_app/features/list_expenses/business/usecases/add_expense.dart';
import 'package:intl/intl.dart';

import '../../../business/usecases/get_expenses.dart';
import '../../../business/usecases/update_expense.dart';

class RemoteExpensesController extends GetxController {
  final GetExpensesUseCase _getExpensesUseCase;
  final AddExpensesUseCase _addExpensesUseCase;
  final UpdateExpensesUseCase _updateExpensesUseCase;

  // TODO: implementar a adição, a atualização e a remoção de expenses

  RemoteExpensesController(this._getExpensesUseCase, this._addExpensesUseCase,
      this._updateExpensesUseCase);

  RxList<ExpenseEntity> allExpenses = <ExpenseEntity>[].obs;
  Rx<double> totalAmount = 0.0.obs;

  // Expense props
  Rx<String> description = ''.obs;
  Rx<String> expenseDate = ''.obs;
  Rx<String> amount = ''.obs;
  Rx<String> idExpense = ''.obs;

  Future<List<ExpenseEntity>> onGetExpenses() async {
    final data = await _getExpensesUseCase();

    if (data != null && data.isNotEmpty) {
      allExpenses.value = data;
      setTotalAmount(data);

      return data;
    } else {
      return <ExpenseEntity>[];
    }
  }

  Future<void> deleteExpense(String id) async {
    print("botão de deletar expense foi pressionado");
  }

  Future<bool> createExpense() async {
    final data = await _addExpensesUseCase.call(
      params: ExpenseEntity(
        description: description.value,
        expenseDate: convertDateFormat(expenseDate.value),
        amount: double.parse(amount.value),
      ),
    );

    if (data != null) {
      allExpenses.add(data);
      setTotalAmount(allExpenses);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateExpense(String idExpense) async {
    final data = await _updateExpensesUseCase(
      params: ExpenseEntity(
        description: description.value,
        expenseDate: convertDateFormat(expenseDate.value),
        amount: double.parse(amount.value),
        id: idExpense,
      ),
    );

    if (data != null) {
      int indexToReplace = allExpenses.indexWhere((obj) => obj.id == idExpense);
      if (indexToReplace != -1) {
        allExpenses[indexToReplace] = data;
      }
      setTotalAmount(allExpenses);

      return true;
    } else {
      return false;
    }
  }

  void setTotalAmount(List<ExpenseEntity> expenseEntities) {
    totalAmount.value = 0.0;
    for (var element in expenseEntities) {
      totalAmount.value += element.amount!;
    }
  }

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateTime parsedDate = inputFormat.parse(inputDate);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
    String outputDate = outputFormat.format(parsedDate);

    return outputDate;
  }

  bool checkSubmitAddExpenseForm() {
    if (description.value != '' &&
        expenseDate.value != '' &&
        amount.value != '') {
      return true;
    } else {
      return false;
    }
  }
}
