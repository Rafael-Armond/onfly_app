import '../../../../../core/usecase/use_case.dart';
import '../../entities/expense_entity.dart';
import '../../repository/expense_repository.dart';

class GetExpensesLocallyUseCase implements UseCase<List<ExpenseEntity>, void> {
  final ExpenseRepository _expenseRepository;

  GetExpensesLocallyUseCase(this._expenseRepository);

  @override
  Future<List<ExpenseEntity>?> call({void params}) {
    return _expenseRepository.getExpensesLocaly();
  }
}
