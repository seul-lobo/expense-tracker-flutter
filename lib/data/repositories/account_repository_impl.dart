import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasource/account_local_data_source.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource localDataSource;

  AccountRepositoryImpl(this.localDataSource);

  AccountModel _toModel(AccountEntity e) {
    return AccountModel(
      id: e.id,
      name: e.name,
      balance: e.balance,
      colorHex: e.colorHex,
      isDefault: e.isDefault,
      isExcluded: e.isExcluded,
      isSelected: e.isSelected,
    );
  }

  AccountEntity _toEntity(AccountModel m) {
    return AccountEntity(
      id: m.id,
      name: m.name,
      balance: m.balance,
      colorHex: m.colorHex,
      isDefault: m.isDefault,
      isExcluded: m.isExcluded,
      isSelected: m.isSelected,
    );
  }

  @override
  Future<void> saveAccounts(List<AccountEntity> accounts) {
    final models = accounts.map(_toModel).toList();
    return localDataSource.saveAccounts(models);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final models = await localDataSource.getAccounts();
    return models.map(_toEntity).toList();
  }

  @override
  Future<void> updateAccount(AccountEntity account, int index) {
    final model = _toModel(account);
    return localDataSource.updateAccount(model, index);
  }

  @override
  Future<void> deleteAccount(int index) {
    return localDataSource.deleteAccount(index);
  }

  @override
  Future<AccountEntity?> getAccountById(int id) async {
    final models = await localDataSource.getAccounts();
    final match = models.firstWhere((a) => a.id == id);
    // ignore: unnecessary_null_comparison
    return match != null ? _toEntity(match) : null;
  }

  @override
  Future<void> updateAccountById(AccountEntity updatedAccount) async {
    final models = await localDataSource.getAccounts();
    final index = models.indexWhere((a) => a.id == updatedAccount.id);
    if (index == -1) throw Exception('Account not found');
    final model = _toModel(updatedAccount);
    return localDataSource.updateAccount(model, index);
  }
}
