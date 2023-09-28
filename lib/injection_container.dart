import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'features/list_expenses/business/usecases/add_expense.dart';
import 'features/list_expenses/business/usecases/get_expenses.dart';
import 'features/list_expenses/business/usecases/local/add_expense_locally.dart';
import 'features/list_expenses/business/usecases/local/get_expenses_locally.dart';
import 'features/list_expenses/business/usecases/local/remove_expense_locally.dart';
import 'features/list_expenses/business/usecases/remove_expense.dart';
import 'features/list_expenses/business/usecases/update_expense.dart';
import 'features/list_expenses/data/data_sources/local/onfly_db_expenses.dart';
import 'features/list_expenses/data/data_sources/remote/onfly_api_service.dart';
import 'features/list_expenses/data/repository/expense_repository_impl.dart';
import 'features/list_expenses/presentation/controllers/local/local_expenses_controller.dart';
import 'features/list_expenses/presentation/controllers/remote/remote_expenses_controller.dart';

final sl = GetIt.instance;

Future<void> dependencyManagement() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  Get.put(OnflyDBService());
  Get.put(OnflyApiService());
  Get.put(ExpenseRepositoryImpl(
      Get.find<OnflyApiService>(), Get.find<OnflyDBService>()));

  Get.put(GetExpensesUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(AddExpensesUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(UpdateExpensesUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(RemoveExpensesUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(AddExpensesLocallyUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(GetExpensesLocallyUseCase(Get.find<ExpenseRepositoryImpl>()));
  Get.put(RemoveExpensesLocallyUseCase(Get.find<ExpenseRepositoryImpl>()));

  Get.put(LocalExpensesController(
    Get.find<AddExpensesLocallyUseCase>(),
    Get.find<GetExpensesLocallyUseCase>(),
    Get.find<RemoveExpensesLocallyUseCase>(),
  ));
  Get.put(RemoteExpensesController(
      Get.find<GetExpensesUseCase>(),
      Get.find<AddExpensesUseCase>(),
      Get.find<UpdateExpensesUseCase>(),
      Get.find<RemoveExpensesUseCase>(),
      Get.find<LocalExpensesController>()));
}
