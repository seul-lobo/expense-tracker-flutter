class AccountEntity {
  final int id;
  final String name;
  final double balance;
  final int colorHex;
  final bool isDefault;
  final bool isExcluded;
  final bool isSelected;

  AccountEntity({
    required this.id,
    required this.name,
    required this.balance,
    required this.colorHex,
    required this.isDefault,
    required this.isExcluded,
    this.isSelected = false,
  });
}
