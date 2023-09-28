import '../../../../core/usecase/use_case.dart';
import '../entities/expense_entity.dart';
import '../repository/expense_repository.dart';

class GetExpensesUseCase implements UseCase<List<ExpenseEntity>, void> {
  final ExpenseRepository _expenseRepository;

  GetExpensesUseCase(this._expenseRepository);

  @override
  Future<List<ExpenseEntity>?> call({void params}) {
    return _expenseRepository.getAllExpenses();
  }
}
