import 'package:hive/hive.dart';
import '../../../domain/entities/debt_entity.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 5)
class DebtModel extends HiveObject implements DebtEntity {
  @HiveField(0)
  @override
  String name;

  @HiveField(1)
  @override
  String description;

  @HiveField(2)
  @override
  double amount;

  @HiveField(3)
  @override
  DateTime dueDate;

  @HiveField(4)
  @override
  bool isDebt;

  @HiveField(5)
  @override
  int accountId;

  DebtModel({
    required this.name,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.isDebt,
    required this.accountId,
  });
}
