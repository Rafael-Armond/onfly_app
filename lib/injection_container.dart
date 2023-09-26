import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/list_expenses/business/repository/expense_repository.dart';
import 'features/list_expenses/business/usecases/add_expense.dart';
import 'features/list_expenses/business/usecases/get_expenses.dart';
import 'features/list_expenses/business/usecases/update_expense.dart';
import 'features/list_expenses/data/data_sources/remote/onfly_api_service.dart';
import 'features/list_expenses/data/repository/expense_repository_impl.dart';
import 'features/list_expenses/presentation/controllers/remote/remote_expenses_controller.dart';

final sl = GetIt.instance;

Future<void> dependencyManagement() async {
  // final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  // sl.registerSingleton<AppDatabase>(database);

  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Dependencies
  sl.registerSingleton<OnflyApiService>(OnflyApiService());
  sl.registerSingleton<ExpenseRepository>(ExpenseRepositoryImpl(sl()));

  // Use Cases
  //Get.put(GetExpensesUseCase(Get.find<ExpenseRepository>()));
  sl.registerSingleton<GetExpensesUseCase>(GetExpensesUseCase(sl()));
  sl.registerSingleton<AddExpensesUseCase>(AddExpensesUseCase(sl()));
  sl.registerSingleton<UpdateExpensesUseCase>(UpdateExpensesUseCase(sl()));

  // Presentation Controllers
  //Get.put(RemoteExpensesController(Get.find<GetExpensesUseCase>()));
  sl.registerSingleton<RemoteExpensesController>(
      RemoteExpensesController(sl(), sl(), sl()));
}
