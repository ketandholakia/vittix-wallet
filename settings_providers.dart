import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Service and Core Providers ---

// Provider for SharedPreferences, which is loaded asynchronously.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

// --- Theme Provider ---

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;
  static const _themeKey = 'themeMode';

  ThemeModeNotifier(this._prefs) : super(_prefs == null ? ThemeMode.system : ThemeMode.values.firstWhere((e) => e.name == _prefs.getString(_themeKey), orElse: () => ThemeMode.system));

  void updateThemeMode(ThemeMode newMode) {
    if (newMode != state) {
      _prefs?.setString(_themeKey, newMode.name);
      state = newMode;
    }
  }
}

// --- Currency Providers ---

enum Currency { INR, USD, EUR, GBP }

class CurrencyInfo {
  final String symbol;
  final String locale;
  CurrencyInfo(this.symbol, this.locale);
}

final Map<Currency, CurrencyInfo> currencyData = {
  Currency.INR: CurrencyInfo('₹', 'en_IN'),
  Currency.USD: CurrencyInfo('\$', 'en_US'),
  Currency.EUR: CurrencyInfo('€', 'de_DE'),
  Currency.GBP: CurrencyInfo('£', 'en_GB'),
};

final currencyProvider = StateNotifierProvider<CurrencyNotifier, Currency>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return CurrencyNotifier(prefs);
});

class CurrencyNotifier extends StateNotifier<Currency> {
  final SharedPreferences? _prefs;
  static const _currencyKey = 'currency';

  CurrencyNotifier(this._prefs) : super(_prefs == null ? Currency.INR : Currency.values.byName(_prefs.getString(_currencyKey) ?? Currency.INR.name));

  void updateCurrency(Currency newCurrency) {
    if (newCurrency != state) {
      _prefs?.setString(_currencyKey, newCurrency.name);
      state = newCurrency;
    }
  }
}

final currencyFormatProvider = Provider<NumberFormat>((ref) {
  final currency = ref.watch(currencyProvider);
  final info = currencyData[currency]!;
  return NumberFormat.currency(locale: info.locale, symbol: info.symbol);
});