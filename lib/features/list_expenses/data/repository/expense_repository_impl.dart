import 'package:dio/dio.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';

import '../../../../core/error/failure.dart';
import '../../business/repository/expense_repository.dart';
import '../data_sources/local/onfly_db_expenses.dart';
import '../data_sources/remote/onfly_api_service.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final IOnflyApiService _onflyApiService;
  final IOnflyDBService _onflyDBService;

  ExpenseRepositoryImpl(this._onflyApiService, this._onflyDBService);

  @override
  Future<List<ExpenseEntity>?> getAllExpenses() async {
    try {
      final expense = await _onflyApiService.getAllExpenses();
      final expenseEntities = expense?.items?.map((element) {
        return ExpenseEntity(
          id: element.id,
          amount: element.amount,
          collectionName: element.collectionName,
          created: element.created,
          description: element.description,
          expenseDate: element.expenseDate,
          latitude: element.latitude,
          longitude: element.longitude,
          updated: element.updated,
          persisted: true,
        );
      }).toList();

      return expenseEntities;
    } catch (e) {
      getExpensesLocaly();
      throw Failure(message: 'Não foi possível carregar os dados da web');
    }
  }

  @override
  Future<ExpenseEntity?> createExpense(ExpenseEntity expenseEntity) async {
    try {
      final createdExpense =
          await _onflyApiService.createExpense(expenseEntity);
      return ExpenseEntity(
        id: createdExpense?.id,
        amount: createdExpense?.amount,
        collectionName: createdExpense?.collectionName,
        created: createdExpense?.created,
        description: createdExpense?.description,
        expenseDate: createdExpense?.expenseDate,
        latitude: createdExpense?.latitude,
        longitude: createdExpense?.longitude,
        updated: createdExpense?.updated,
        persisted: true,
      );
    } catch (e) {
      saveExpenseLocaly(expenseEntity);
      throw Failure(message: 'Não foi possível persistir o dado na web');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      _onflyApiService.deleteExpense(id);
    } on DioException {
      throw Failure(message: 'Não foi possível remover o dado');
    }
  }

  @override
  Future<ExpenseEntity?> updateExpense(ExpenseEntity expenseEntity) async {
    try {
      final body = ExpenseEntity(
          description: expenseEntity.description,
          expenseDate: expenseEntity.expenseDate,
          amount: expenseEntity.amount,
          latitude: expenseEntity.latitude,
          longitude: expenseEntity.longitude,
          id: expenseEntity.id);
      final updatedExpense = await _onflyApiService.updateExpense(body);
      return ExpenseEntity(
        description: updatedExpense?.description,
        expenseDate: updatedExpense?.expenseDate,
        amount: updatedExpense?.amount,
        latitude: updatedExpense?.latitude,
        longitude: updatedExpense?.longitude,
      );
    } on DioException {
      throw Failure(message: 'Não foi possível persistir o dado');
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesLocaly() async {
    try {
      final listExpenses = _onflyDBService.getExpensesLocaly();
      return listExpenses;
    } on DioException {
      throw Failure(message: 'Não foi possível persistir o dado');
    }
  }

  @override
  Future<void> removeExpenseLocaly(String id) async {
    try {
      await _onflyDBService.removeExpenseLocaly(id);
    } on DioException {
      throw Failure(message: 'Não foi possível persistir o dado');
    }
  }

  @override
  Future<ExpenseEntity> saveExpenseLocaly(ExpenseEntity expense) {
    try {
      final createdExpense = _onflyDBService.saveExpenseLocaly(expense);
      return createdExpense;
    } on DioException {
      throw Failure(message: 'Não foi possível persistir o dado');
    }
  }
}
