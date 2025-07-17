import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository repository;

  TransactionCubit(this.repository) : super(TransactionInitial());

  Future<void> loadTransactions() async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getAllTransactions();
      print("✅ Loaded ${transactions.length} transactions");
      emit(TransactionLoaded(transactions));
    } catch (e) {
      print("❌ Error loading transactions: $e");
      emit(TransactionError("Failed to load transactions"));
    }
  }

  Future<void> addTransaction(TransactionEntity entity) async {
    try {
      await repository.addTransaction(entity);
      await loadTransactions(); // ✅ FIX: Await to ensure state update completes
    } catch (e) {
      print("❌ Error adding transaction: $e");
      emit(TransactionError("Failed to add transaction"));
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await repository.deleteTransaction(id);
      await loadTransactions(); // ✅ also make sure this is awaited
    } catch (e) {
      print("❌ Error deleting transaction: $e");
      emit(TransactionError("Failed to delete transaction"));
    }
  }
}
