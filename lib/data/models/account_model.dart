import 'package:hive/hive.dart';
part 'account_model.g.dart';

@HiveType(typeId: 2)
class AccountModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double balance;

  @HiveField(3)
  final int colorHex;

  @HiveField(4)
  final bool isDefault;

  @HiveField(5)
  final bool isExcluded;

  @HiveField(6)
  final bool isSelected;

  AccountModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.colorHex,
    required this.isDefault,
    required this.isExcluded,
    this.isSelected = false,
  });
}
