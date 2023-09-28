import '../../../../../core/usecase/use_case.dart';
import '../../entities/expense_entity.dart';
import '../../repository/expense_repository.dart';

class AddExpensesLocallyUseCase
    implements UseCase<ExpenseEntity?, ExpenseEntity?> {
  final ExpenseRepository _expenseRepository;

  AddExpensesLocallyUseCase(this._expenseRepository);

  @override
  Future<ExpenseEntity?> call({ExpenseEntity? params}) {
    return _expenseRepository.saveExpenseLocaly(params!);
  }
}
