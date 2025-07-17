import '../entities/debt_entity.dart';

abstract class DebtRepository {
  Future<void> addDebt(DebtEntity debt);
  Future<void> deleteDebt(DebtEntity debt);
  Future<void> updateDebt(DebtEntity debt);
  Future<List<DebtEntity>> getAllDebts();
}
