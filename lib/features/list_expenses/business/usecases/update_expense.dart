import '../../../../core/usecase/use_case.dart';
import '../entities/expense_entity.dart';
import '../repository/expense_repository.dart';

class UpdateExpensesUseCase implements UseCase<ExpenseEntity?, ExpenseEntity?> {
  final ExpenseRepository _expenseRepository;

  UpdateExpensesUseCase(this._expenseRepository);

  @override
  Future<ExpenseEntity?> call({ExpenseEntity? params}) {
    return _expenseRepository.updateExpense(params!);
  }
}
