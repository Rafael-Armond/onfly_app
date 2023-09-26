import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  // API methods
  Future<List<ExpenseEntity>?> getAllExpenses();
  Future<ExpenseEntity?> createExpense(ExpenseEntity expenseEntity);
  Future<ExpenseEntity?> updateExpense(ExpenseEntity expenseEntity);
  Future<void> deleteExpense(String id);

  // Database methods
  Future<List<ExpenseEntity>> getExpensesLocaly();
  Future<void> saveExpenseLocaly(ExpenseEntity expense);
  Future<void> removeExpenseLocaly(String id);
}
