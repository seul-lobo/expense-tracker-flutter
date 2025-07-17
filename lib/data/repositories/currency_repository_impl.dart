import '../../domain/entities/currency_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasource/currency_local_data_source.dart';
import '../models/currency_model.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveCurrencies(List<CurrencyEntity> currencies) async {
    final models = currencies
        .map(
          (e) => CurrencyModel(
            symbol: e.symbol,
            code: e.name,
            isSelected: e.isSelected,
          ),
        )
        .toList();
    await localDataSource.saveCurrencies(models);
  }

  @override
  Future<List<CurrencyEntity>> getCurrencies() async {
    final models = await localDataSource.getCurrencies();
    return models
        .map(
          (m) => CurrencyEntity(
            name: m.code,
            symbol: m.symbol,
            isSelected: m.isSelected,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateCurrency(CurrencyEntity currency, int index) async {
    final model = CurrencyModel(
      symbol: currency.symbol,
      code: currency.name,
      isSelected: currency.isSelected,
    );
    await localDataSource.updateCurrency(model, index);
  }
}
