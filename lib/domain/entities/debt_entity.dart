abstract class DebtEntity {
  final String name;
  final String description;
  final double amount;
  final DateTime dueDate;
  final bool isDebt; // true = debt, false = credit
  final int accountId;

  DebtEntity({
    required this.accountId,
    required this.name,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.isDebt,
  });
}
