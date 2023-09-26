import 'package:flutter/material.dart';
import 'package:onfly_app/features/list_expenses/presentation/pages/add_update_expense/add_update_expense.dart';
import 'package:onfly_app/features/list_expenses/presentation/pages/list_expenses/list_expense.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(ListExpenses());

      case '/addUpdateExpense':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey('data')) {
          return _materialRoute(AddUpdateExpense(addExpenseMode: args['data']));
        } else {
          return _materialRoute(ListExpenses());
        }

      default:
        return _materialRoute(ListExpenses());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
