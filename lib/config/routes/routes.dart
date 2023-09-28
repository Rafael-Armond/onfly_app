import 'package:flutter/material.dart';
import 'package:onfly_app/features/list_expenses/business/entities/expense_entity.dart';
import 'package:onfly_app/features/list_expenses/presentation/pages/add_update_expense/add_update_expense.dart';
import 'package:onfly_app/features/list_expenses/presentation/pages/list_expenses/list_expense.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(ListExpenses());

      case '/addUpdateExpense':
        final args = settings.arguments as Map<String, dynamic>;
        final expenseMode = args["addExpenseMode"];
        if (args["addExpenseMode"] != null && expenseMode != null) {
          if (expenseMode) {
            return _materialRoute(
              AddUpdateExpense(
                addExpenseMode: expenseMode,
                expenseEntity: ExpenseEntity(
                  description: '',
                  amount: 0.0,
                  expenseDate: '',
                  latitude: '',
                  longitude: '',
                ),
              ),
            );
          } else {
            return _materialRoute(
              AddUpdateExpense(
                addExpenseMode: expenseMode,
                expenseEntity: args["expenseEntity"],
              ),
            );
          }
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
