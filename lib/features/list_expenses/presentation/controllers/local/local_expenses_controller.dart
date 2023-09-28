import 'package:get/get.dart';

import '../../../business/entities/expense_entity.dart';
import '../../../business/usecases/local/add_expense_locally.dart';
import '../../../business/usecases/local/get_expenses_locally.dart';
import '../../../business/usecases/local/remove_expense_locally.dart';

class LocalExpensesController extends GetxController {
  final AddExpensesLocallyUseCase _addExpensesLocallyUseCase;
  final GetExpensesLocallyUseCase _getExpensesLocallyUseCase;
  final RemoveExpensesLocallyUseCase _removeExpensesLocallyUseCase;

  LocalExpensesController(this._addExpensesLocallyUseCase,
      this._getExpensesLocallyUseCase, this._removeExpensesLocallyUseCase);

  Future<ExpenseEntity>? createExpenseLocally(
      ExpenseEntity expenseEntity) async {
    try {
      final localAddedExpense =
          await _addExpensesLocallyUseCase.call(params: expenseEntity);
      if (localAddedExpense != null) {
        return localAddedExpense;
      }
      return localAddedExpense!;
    } on Exception {
      throw Exception("Não foi possível adicionar a despesa localmente");
    }
  }

  Future<List<ExpenseEntity>> getAllLocalExpenses() async {
    try {
      final localExpenses = await _getExpensesLocallyUseCase.call();

      if (localExpenses != null) {
        return localExpenses;
      } else {
        return <ExpenseEntity>[];
      }
    } on Exception {
      throw Exception("Não foi possível buscar os dados localmente");
    }
  }

  Future<void> removeLocalExpense(String description) async {
    try {
      await _removeExpensesLocallyUseCase.call(params: 'Key_$description');
    } on Exception {
      throw Exception("Não foi possível buscar os dados localmente");
    }
  }
}
