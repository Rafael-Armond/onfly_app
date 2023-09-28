import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';
import 'package:onfly_app/features/list_expenses/business/usecases/add_expense.dart';
import 'package:intl/intl.dart';

import '../../../business/usecases/get_expenses.dart';
import '../../../business/usecases/remove_expense.dart';
import '../../../business/usecases/update_expense.dart';
import '../local/local_expenses_controller.dart';

class RemoteExpensesController extends GetxController {
  final GetExpensesUseCase _getExpensesUseCase;
  final AddExpensesUseCase _addExpensesUseCase;
  final UpdateExpensesUseCase _updateExpensesUseCase;
  final RemoveExpensesUseCase _removeExpensesUseCase;
  final LocalExpensesController _localExpensesController;

  RemoteExpensesController(
      this._getExpensesUseCase,
      this._addExpensesUseCase,
      this._updateExpensesUseCase,
      this._removeExpensesUseCase,
      this._localExpensesController);

  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectivityResult> connectivityResult =
      Rx<ConnectivityResult>(ConnectivityResult.none);

  RxList<ExpenseEntity> allExpenses = <ExpenseEntity>[].obs;
  Rx<double> totalAmount = 0.0.obs;
  Rx<ExpenseEntity> expenseEntity = ExpenseEntity().obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((result) async {
      connectivityResult.value = result;
      if (isConnected) {
        if (await checkApi()) {
          sincExpensesWebLocal();
        }
      }
    });
  }

  bool get isConnected =>
      connectivityResult.value == ConnectivityResult.wifi ||
      connectivityResult.value == ConnectivityResult.mobile;

  Future<void> sincExpensesWebLocal() async {
    final localExpenses = await _localExpensesController.getAllLocalExpenses();
    for (var localExpense in localExpenses) {
      await createExpense(localExpense);
      await _localExpensesController
          .removeLocalExpense(localExpense.description!);
    }
  }

  Future<List<ExpenseEntity>> onGetExpenses() async {
    try {
      if (isConnected) {
        final data = await _getExpensesUseCase.call();

        if (data != null && data.isNotEmpty) {
          allExpenses.value = data;
          setTotalAmount(data);

          return data;
        } else {
          return <ExpenseEntity>[];
        }
      } else {
        final data = await _localExpensesController.getAllLocalExpenses();
        if (data.isNotEmpty) {
          allExpenses.value = data;
          setTotalAmount(data);

          return data;
        } else {
          return <ExpenseEntity>[];
        }
      }
    } on Exception {
      throw Exception("Não foi possível buscar os dados remotamente");
    }
  }

  Future<bool> deleteExpense(String id) async {
    try {
      await _removeExpensesUseCase.call(params: id);
      allExpenses.removeWhere((element) => element.id == id);
      setTotalAmount(allExpenses);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createExpense(ExpenseEntity expenseEntity) async {
    try {
      if (isConnected) {
        final data = await _addExpensesUseCase.call(
          params: ExpenseEntity(
            description: expenseEntity.description,
            expenseDate: convertDateFormat(expenseEntity.expenseDate!),
            amount: double.parse(expenseEntity.amount.toString()),
            latitude: "80.121212",
            longitude: "40.232323",
          ),
        );

        if (data != null) {
          allExpenses.add(data);
          setTotalAmount(allExpenses);

          return true;
        } else {
          return false;
        }
      } else {
        final param = ExpenseEntity(
          id: expenseEntity.hashCode.toString(),
          description: expenseEntity.description,
          expenseDate: convertDateFormat(expenseEntity.expenseDate!),
          amount: double.parse(expenseEntity.amount.toString()),
          latitude: "80.121212",
          longitude: "40.232323",
        );
        final data = await _localExpensesController.createExpenseLocally(param);
        if (data != null) {
          allExpenses.add(data);
          setTotalAmount(allExpenses);

          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseEntity expense) async {
    try {
      final requestBody = ExpenseEntity(
        description: expense.description,
        expenseDate: convertDateFormat(expense.expenseDate!),
        amount: expense.amount,
        latitude: expense.latitude,
        longitude: expense.longitude,
        id: expense.id,
      );

      final data = await _updateExpensesUseCase(params: requestBody);

      if (data != null) {
        int indexToReplace =
            allExpenses.indexWhere((obj) => obj.id == expense.id);
        if (indexToReplace != -1) {
          allExpenses[indexToReplace] = data;
        }
        setTotalAmount(allExpenses);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkApi() async {
    try {
      await _getExpensesUseCase.call();
      return true;
    } on Exception {
      return false;
    }
  }

  void setTotalAmount(List<ExpenseEntity> expenseEntities) {
    totalAmount.value = 0.0;
    for (var element in expenseEntities) {
      totalAmount.value += element.amount!;
    }
  }

  String getFormatedDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year}";

      return formattedDate;
    } catch (e) {
      return '01/01/1000';
    }
  }

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateTime parsedDate = inputFormat.parse(inputDate);
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
    String outputDate = outputFormat.format(parsedDate);

    return outputDate;
  }

  bool checkSubmitAddExpenseForm(ExpenseEntity expenseEntity) {
    if (expenseEntity.description != '' &&
        expenseEntity.expenseDate != '' &&
        expenseEntity.amount.toString() != '') {
      return true;
    } else {
      return false;
    }
  }
}
