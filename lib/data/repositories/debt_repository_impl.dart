import 'package:expense_tracker/domain/entities/debt_entity.dart';
import 'package:expense_tracker/domain/repositories/debt_repository.dart';
import '../../data/models/debt_model.dart';
import '../datasource/debt_local_data_source.dart';

class DebtRepositoryImpl implements DebtRepository {
  final DebtLocalDataSource _localDataSource;

  DebtRepositoryImpl(this._localDataSource);

  @override
  Future<void> addDebt(DebtEntity debt) async {
    await _localDataSource.addDebt(_toModel(debt));
  }

  @override
  Future<void> deleteDebt(DebtEntity debt) async {
    if (debt is DebtModel) {
      await _localDataSource.deleteDebt(debt);
    }
  }

  @override
  Future<void> updateDebt(DebtEntity debt) async {
    if (debt is DebtModel) {
      await _localDataSource.updateDebt(debt);
    }
  }

  @override
  Future<List<DebtEntity>> getAllDebts() async {
    return await _localDataSource.getAllDebts();
  }

  DebtModel _toModel(DebtEntity debt) {
    return DebtModel(
      name: debt.name,
      description: debt.description,
      amount: debt.amount,
      dueDate: debt.dueDate,
      isDebt: debt.isDebt,
      accountId: debt.accountId,
    );
  }
}
