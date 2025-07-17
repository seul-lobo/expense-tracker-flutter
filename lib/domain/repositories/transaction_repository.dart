import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}
