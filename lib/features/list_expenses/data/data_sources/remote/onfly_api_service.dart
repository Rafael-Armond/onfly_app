import 'package:dio/dio.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/failure.dart';
import '../../../business/entities/expense_entity.dart';
import '../../models/expense_model.dart';

abstract class IOnflyApiService {
  Future<Expense>? getAllExpenses();
  Future<ExpenseEntity>? createExpense(ExpenseEntity expense);
  Future<ExpenseEntity>? updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
}

class OnflyApiService implements IOnflyApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: onflyApiBaseUrl,
      headers: {
        'Authorization': authorizationToken,
      },
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 2),
    ),
  );

  @override
  Future<ExpenseEntity>? createExpense(ExpenseEntity expense) async {
    try {
      Response<dynamic> response = await dio.post<Map<String, dynamic>>(
        '/collections/expense_B7fAae/records',
        data: expense.toJson(),
      );

      return ExpenseEntity.fromJson(response.data);
    } on Exception {
      throw Failure(message: 'Não foi possível carregar os dados');
    }
  }

  @override
  Future<Expense>? getAllExpenses() async {
    try {
      final response = await dio.get('/collections/expense_B7fAae/records');
      return Expense.fromJson(response.data);
    } on Exception {
      throw Failure(message: 'Não foi possível carregar os dados');
    }
  }

  @override
  Future<ExpenseEntity>? updateExpense(ExpenseEntity expense) async {
    try {
      Response<dynamic> response = await dio.patch<Map<String, dynamic>>(
        '/collections/expense_B7fAae/records/${expense.id}',
        data: expense.toJson(),
      );

      return ExpenseEntity.fromJson(response.data);
    } on Exception {
      throw Failure(message: 'Não foi possível carregar os dados');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await dio.delete('/collections/expense_B7fAae/records/$id');
    } on Exception {
      throw Failure(message: 'Não foi possível carregar os dados');
    }
  }
}
