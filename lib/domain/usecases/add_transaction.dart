import '../../data/models/transaction_model.dart';
import '../../data/datasource/transaction_local_data_source.dart';

class AddTransactionUseCase {
  final TransactionLocalDataSource dataSource;

  AddTransactionUseCase(this.dataSource);

  Future<void> call(TransactionModel transaction) {
    return dataSource.addTransaction(transaction);
  }
}
