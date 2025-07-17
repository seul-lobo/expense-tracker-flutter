import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String type; // Expense, Income, Transfer

  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime dateTime;

  @HiveField(7)
  final int accountId;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.type,
    required this.category,
    required this.dateTime,
    required this.accountId, // ✅ fix: now named properly
  });
}
