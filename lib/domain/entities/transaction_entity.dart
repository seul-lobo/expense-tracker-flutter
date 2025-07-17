class TransactionEntity {
  final String id;
  final String name;
  final double amount;
  final String description;
  final String type;
  final String category;
  final DateTime dateTime;

  // ✅ NEW FIELD
  final int accountId;

  const TransactionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.type,
    required this.category,
    required this.dateTime,
    required this.accountId, // ✅ REQUIRED
  });
}
