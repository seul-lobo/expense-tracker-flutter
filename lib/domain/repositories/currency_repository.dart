import '../entities/currency_entity.dart';

abstract class CurrencyRepository {
  Future<void> saveCurrencies(List<CurrencyEntity> currencies);
  Future<List<CurrencyEntity>> getCurrencies();
  Future<void> updateCurrency(CurrencyEntity currency, int index);
}
