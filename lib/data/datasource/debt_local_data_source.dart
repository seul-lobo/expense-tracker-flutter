import 'package:hive/hive.dart';
import '../../data/models/debt_model.dart';

abstract class DebtLocalDataSource {
  Future<void> addDebt(DebtModel debt);
  Future<void> deleteDebt(DebtModel debt);
  Future<void> updateDebt(DebtModel debt);
  Future<List<DebtModel>> getAllDebts();
}

class DebtLocalDataSourceImpl implements DebtLocalDataSource {
  final Box<DebtModel> debtBox;

  DebtLocalDataSourceImpl(this.debtBox);

  @override
  Future<void> addDebt(DebtModel debt) async {
    await debtBox.add(debt);
  }

  @override
  Future<void> deleteDebt(DebtModel debt) async {
    await debt.delete();
  }

  @override
  Future<void> updateDebt(DebtModel debt) async {
    await debt.save();
  }

  @override
  Future<List<DebtModel>> getAllDebts() async {
    return debtBox.values.toList();
  }
}
