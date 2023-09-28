import '../../../../../core/usecase/use_case.dart';
import '../../repository/expense_repository.dart';

class RemoveExpensesLocallyUseCase implements UseCase<void, String> {
  final ExpenseRepository _expenseRepository;

  RemoveExpensesLocallyUseCase(this._expenseRepository);

  @override
  Future<void> call({String? params}) {
    return _expenseRepository.removeExpenseLocaly(params!);
  }
}
