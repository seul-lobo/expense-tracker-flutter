import 'package:hive/hive.dart';
part 'currency_model.g.dart';

@HiveType(typeId: 4)
class CurrencyModel extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final String code;

  @HiveField(2)
  final bool isSelected;

  CurrencyModel({
    required this.symbol,
    required this.code,
    this.isSelected = false,
  });
}
