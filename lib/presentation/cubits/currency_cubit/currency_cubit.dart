import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../data/models/currency_model.dart';
import 'currency_state.dart';
import '../../../domain/entities/currency_entity.dart';
import '../../../domain/repositories/currency_repository.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyCubit(this._repository) : super(CurrencyInitial()) {
    loadCurrencies();
  }

  Future<void> debugCurrencies() async {
    try {
      final box = await Hive.openBox<CurrencyModel>('currencyBox');
      print(
        'Hive currencyBox contents: ${box.values.map((c) => "${c.code}: ${c.symbol}, ${c.isSelected}").toList()}',
      );
    } catch (e) {
      print('Error debugging currencyBox: $e');
    }
  }

  Future<void> loadCurrencies() async {
    try {
      emit(CurrencyLoading());
      await debugCurrencies();
      final currencies = await _repository.getCurrencies();
      print('Loaded currencies: ${currencies.length}');
      if (currencies.isEmpty) {
        print('No currencies found in "currencyBox", initializing defaults');
        await initDefaultCurrencies();
        final updatedCurrencies = await _repository.getCurrencies();
        emit(CurrencyLoaded(updatedCurrencies));
      } else {
        emit(CurrencyLoaded(currencies));
      }
    } catch (e) {
      print('Error loading currencies: $e');
      emit(CurrencyError("Failed to load currencies: $e"));
    }
  }

  Future<void> initDefaultCurrencies() async {
    try {
      // Add slight delay to avoid rapid state emissions
      await Future.delayed(const Duration(milliseconds: 100));
      final defaultCurrencies = [
        CurrencyEntity(name: "PKR", symbol: "₨", isSelected: false),
        CurrencyEntity(name: "USD", symbol: "\$", isSelected: false),
        CurrencyEntity(name: "EUR", symbol: "€", isSelected: false),
        CurrencyEntity(name: "GBP", symbol: "£", isSelected: false),
        CurrencyEntity(name: "INR", symbol: "₹", isSelected: false),
        CurrencyEntity(name: "AED", symbol: "د.إ", isSelected: false),
      ];
      print(
        'Initializing default currencies: ${defaultCurrencies.map((c) => c.name).toList()}',
      );
      await saveCurrencies(defaultCurrencies);
    } catch (e) {
      print('Error initializing default currencies: $e');
      emit(CurrencyError("Failed to initialize currencies: $e"));
    }
  }

  Future<void> saveCurrencies(List<CurrencyEntity> currencies) async {
    try {
      await _repository.saveCurrencies(currencies);
      print('Currencies saved: ${currencies.length}');
      await loadCurrencies();
    } catch (e) {
      print('Error saving currencies: $e');
      emit(CurrencyError("Failed to save currencies: $e"));
    }
  }

  Future<void> updateCurrency(CurrencyEntity currency, int index) async {
    try {
      await _repository.updateCurrency(currency, index);
      print('Currency updated at index $index: ${currency.name}');
      await loadCurrencies();
    } catch (e) {
      print('Error updating currency: $e');
      emit(CurrencyError("Failed to update currency: $e"));
    }
  }
}
