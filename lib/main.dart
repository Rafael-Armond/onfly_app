import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'config/hive/hive_config.dart';
import 'config/routes/routes.dart';
import 'features/list_expenses/presentation/pages/list_expenses/list_expense.dart';
import 'injection_container.dart';

void main() async {
  await HiveConfig.start();

  dependencyManagement();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Onfly',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: ListExpenses(),
      debugShowCheckedModeBanner: false,
    );
  }
}
