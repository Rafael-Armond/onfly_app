import '../../../../core/usecase/use_case.dart';
import '../repository/expense_repository.dart';

class RemoveExpensesUseCase implements UseCase<void, String> {
  final ExpenseRepository _expenseRepository;

  RemoveExpensesUseCase(this._expenseRepository);

  @override
  Future<void> call({String? params}) {
    return _expenseRepository.deleteExpense(params!);
  }
}
