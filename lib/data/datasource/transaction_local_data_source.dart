import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TransactionModel model);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> box;

  TransactionLocalDataSourceImpl(this.box);

  @override
  Future<void> addTransaction(TransactionModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return box.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await box.delete(id);
  }
}
