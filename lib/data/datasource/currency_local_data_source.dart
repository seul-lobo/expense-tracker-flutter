import 'package:hive/hive.dart';
import '../models/currency_model.dart';

abstract class CurrencyLocalDataSource {
  Future<void> saveCurrencies(List<CurrencyModel> currencies);
  Future<List<CurrencyModel>> getCurrencies();
  Future<void> updateCurrency(CurrencyModel currency, int index);
}

class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  final Box<CurrencyModel> box;

  CurrencyLocalDataSourceImpl(this.box);

  @override
  Future<void> saveCurrencies(List<CurrencyModel> currencies) async {
    try {
      await box.clear();
      await box.addAll(currencies);
      print('Saved ${currencies.length} currencies to Hive box "currencyBox": ${currencies.map((c) => c.code).toList()}');
    } catch (e) {
      print('Error saving currencies to "currencyBox": $e');
      rethrow;
    }
  }

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final currencies = box.values.toList();
      print('Retrieved ${currencies.length} currencies from Hive box "currencyBox": ${currencies.map((c) => c.code).toList()}');
      return currencies;
    } catch (e) {
      print('Error retrieving currencies from "currencyBox": $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCurrency(CurrencyModel currency, int index) async {
    try {
      await box.putAt(index, currency);
      print('Updated currency at index $index in "currencyBox": ${currency.code}');
    } catch (e) {
      print('Error updating currency in "currencyBox": $e');
      rethrow;
    }
  }
}