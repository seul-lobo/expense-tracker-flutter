import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTransaction(TransactionEntity entity) {
    final model = TransactionModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      description: entity.description,
      type: entity.type,
      category: entity.category,
      dateTime: entity.dateTime,
      accountId: entity.accountId,
    );
    return localDataSource.addTransaction(model);
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final models = await localDataSource.getAllTransactions();
    return models
        .map(
          (m) => TransactionEntity(
            id: m.id,
            name: m.name,
            amount: m.amount,
            description: m.description,
            type: m.type,
            category: m.category,
            dateTime: m.dateTime,
            accountId: m.accountId
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteTransaction(String id) {
    return localDataSource.deleteTransaction(id);
  }
}
