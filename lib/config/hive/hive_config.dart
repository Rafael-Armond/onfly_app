import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/list_expenses/data/models/adapters/expense.dart';
import 'boxes/expense_box.dart';

class HiveConfig {
  static start() async {
    Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    Hive.registerAdapter(ExpenseAdapter());
    expensesBox = await Hive.openBox<Expense>('expenseBox');
  }
}
