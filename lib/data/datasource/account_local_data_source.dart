import 'package:hive/hive.dart';
import '../models/account_model.dart';

abstract class AccountLocalDataSource {
  Future<void> saveAccounts(List<AccountModel> accounts);
  Future<List<AccountModel>> getAccounts();
  Future<void> updateAccount(AccountModel account, int index);
  Future<void> deleteAccount(int index); // Added method signature
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final Box<AccountModel> box;

  AccountLocalDataSourceImpl(this.box);

  @override
  Future<void> saveAccounts(List<AccountModel> accounts) async {
    await box.clear();
    for (var acc in accounts) {
      await box.add(acc);
    }
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    return box.values.toList();
  }

  @override
  Future<void> updateAccount(AccountModel account, int index) async {
    await box.putAt(index, account);
  }

  @override
  Future<void> deleteAccount(int index) async {
    await box.deleteAt(index);
  }
}
