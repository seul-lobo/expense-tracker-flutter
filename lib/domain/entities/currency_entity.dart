import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  final String name;
  final String symbol;
  final bool isSelected;

  const CurrencyEntity({
    required this.name,
    required this.symbol,
    required this.isSelected,
  });

  CurrencyEntity copyWith({String? name, String? symbol, bool? isSelected}) {
    return CurrencyEntity(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [name, symbol, isSelected];
}
