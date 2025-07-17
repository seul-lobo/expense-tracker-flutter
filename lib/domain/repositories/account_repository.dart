import '../entities/account_entity.dart';

abstract class AccountRepository {
  Future<void> saveAccounts(List<AccountEntity> accounts);
  Future<List<AccountEntity>> getAccounts();
  Future<void> updateAccount(AccountEntity account, int index);
  Future<void> deleteAccount(int index);
  Future<AccountEntity?> getAccountById(int id);
  Future<void> updateAccountById(AccountEntity updatedAccount);
}
