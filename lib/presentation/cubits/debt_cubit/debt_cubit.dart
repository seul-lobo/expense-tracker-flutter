import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../cubits/account_cubit/account_cubit.dart';
import '../../cubits/transaction_cubit/transaction_cubit.dart';

part 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  final DebtRepository debtRepo;
  final AccountCubit accountCubit;
  final TransactionCubit transactionCubit;

  DebtCubit({
    required this.debtRepo,
    required this.accountCubit,
    required this.transactionCubit,
  }) : super(DebtInitial());

  Future<void> loadDebts() async {
    try {
      emit(DebtLoading());
      final debts = await debtRepo.getAllDebts();
      emit(DebtLoaded(debts));
    } catch (e) {
      emit(DebtError('Failed to load debts: $e'));
    }
  }

  Future<void> addDebt(DebtEntity debt) async {
    try {
      emit(DebtLoading());
      await debtRepo.addDebt(debt);
      emit(DebtSuccess('Debt added successfully'));
      await loadDebts();
    } catch (e) {
      emit(DebtError('Failed to add debt: $e'));
    }
  }

  Future<void> deleteDebt(DebtEntity debt) async {
    try {
      emit(DebtLoading());
      await debtRepo.deleteDebt(debt);
      emit(DebtSuccess('Debt deleted successfully'));
      await loadDebts();
    } catch (e) {
      emit(DebtError('Failed to delete debt: $e'));
    }
  }

  Future<void> updateDebt(DebtEntity debt) async {
    try {
      emit(DebtLoading());
      await debtRepo.updateDebt(debt);
      emit(DebtSuccess('Debt updated successfully'));
      await loadDebts();
    } catch (e) {
      emit(DebtError('Failed to update debt: $e'));
    }
  }

  Future<void> payOrCollect(DebtEntity debt, {required bool isCollect}) async {
    try {
      emit(DebtLoading());

      // Update account balance
      await accountCubit.updateBalance(
        debt.accountId,
        debt.amount,
        isCollect, // isCollect = true for credit (add), false for debt (subtract)
      );

      // Create transaction
      final transaction = TransactionEntity(
        id: const Uuid().v4(),
        name: isCollect ? "Credit Collected" : "Debt Paid",
        amount: debt.amount,
        description: debt.description,
        type: isCollect ? "Income" : "Expense",
        category: "Debt",
        dateTime: DateTime.now(),
        accountId: debt.accountId,
      );
      await transactionCubit.addTransaction(transaction);

      // Delete debt
      await debtRepo.deleteDebt(debt);

      emit(DebtSuccess(isCollect ? 'Credit collected' : 'Debt paid'));
      await loadDebts();
    } catch (e) {
      emit(DebtError('Failed to process ${isCollect ? 'collection' : 'payment'}: $e'));
    }
  }
}