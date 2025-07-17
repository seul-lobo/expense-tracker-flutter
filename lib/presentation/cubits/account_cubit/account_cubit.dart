import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/repositories/account_repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository repository;

  AccountCubit(this.repository) : super(AccountInitial());

  Future<void> loadAccounts() async {
    emit(AccountLoading());
    try {
      final accounts = await repository.getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError('Failed to load accounts'));
    }
  }

  Future<void> addAccount(AccountEntity newAccount) async {
    try {
      final currentState = state;
      if (currentState is AccountLoaded) {
        final updatedAccounts = List<AccountEntity>.from(currentState.accounts)
          ..add(newAccount);
        await repository.saveAccounts(updatedAccounts);
        emit(AccountLoaded(updatedAccounts));
      } else {
        // If no accounts loaded yet, treat this as first entry
        await repository.saveAccounts([newAccount]);
        emit(AccountLoaded([newAccount]));
      }
    } catch (e) {
      emit(AccountError('Failed to add account'));
    }
  }

  Future<void> updateBalance(
    int accountId,
    double amount,
    bool isIncome,
  ) async {
    try {
      if (state is AccountLoaded) {
        final accounts = List<AccountEntity>.from(
          (state as AccountLoaded).accounts,
        );
        final index = accounts.indexWhere((acc) => acc.id == accountId);
        if (index == -1) {
          print("⚠️ Account with ID $accountId not found!");
          return;
        }

        final acc = accounts[index];
        final newBalance = isIncome
            ? acc.balance + amount
            : acc.balance - amount;

        final updatedAcc = AccountEntity(
          id: acc.id,
          name: acc.name,
          balance: newBalance,
          colorHex: acc.colorHex,
          isDefault: acc.isDefault,
          isExcluded: acc.isExcluded,
          isSelected: acc.isSelected,
        );

        accounts[index] = updatedAcc;
        await repository.saveAccounts(accounts); // persist changes
        emit(AccountLoaded(accounts));
      }
    } catch (e) {
      emit(AccountError("Failed to update balance"));
    }
  }

  Future<void> saveAccounts(List<AccountEntity> accounts) async {
    emit(AccountLoading());
    try {
      await repository.saveAccounts(accounts);
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError('Failed to save accounts'));
    }
  }

  Future<void> updateAccount(AccountEntity account, int index) async {
    try {
      await repository.updateAccount(account, index);
      final updatedAccounts = await repository.getAccounts();
      emit(AccountLoaded(updatedAccounts));
    } catch (e) {
      emit(AccountError('Failed to update account'));
    }
  }

  Future<void> deleteAccount(int index) async {
    try {
      await repository.deleteAccount(index);
      final updatedAccounts = await repository.getAccounts();
      emit(AccountLoaded(updatedAccounts));
    } catch (e) {
      emit(AccountError('Failed to delete account'));
    }
  }
}
