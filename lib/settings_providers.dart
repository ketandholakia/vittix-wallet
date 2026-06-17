import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

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

enum Currency { INR, USD, EUR, GBP }

enum RolloverMode { disabled, surplusOnly, surplusAndDeficit }

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

final rolloverModeProvider = StateNotifierProvider<RolloverModeNotifier, RolloverMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return RolloverModeNotifier(prefs);
});

class RolloverModeNotifier extends StateNotifier<RolloverMode> {
  final SharedPreferences? _prefs;
  static const _rolloverKey = 'rolloverMode';

  RolloverModeNotifier(this._prefs)
      : super(_prefs == null
            ? RolloverMode.surplusOnly
            : RolloverMode.values.firstWhere(
                (e) => e.name == _prefs.getString(_rolloverKey),
                orElse: () => RolloverMode.surplusOnly,
              ));

  void updateRolloverMode(RolloverMode newMode) {
    if (newMode != state) {
      _prefs?.setString(_rolloverKey, newMode.name);
      state = newMode;
    }
  }
}

final currencyFormatProvider = Provider<NumberFormat>((ref) {
  final currency = ref.watch(currencyProvider);
  final info = currencyData[currency]!;
  return NumberFormat.currency(locale: info.locale, symbol: info.symbol);
});

final pinLockEnabledProvider = StateNotifierProvider<PinLockEnabledNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return PinLockEnabledNotifier(prefs);
});

class PinLockEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;
  static const _key = 'isPinLockEnabled';

  PinLockEnabledNotifier(this._prefs) : super(_prefs?.getBool(_key) ?? false);

  void updatePinLockEnabled(bool enabled) {
    _prefs?.setBool(_key, enabled);
    state = enabled;
  }
}

final biometricsEnabledProvider = StateNotifierProvider<BiometricsEnabledNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return BiometricsEnabledNotifier(prefs);
});

class BiometricsEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;
  static const _key = 'isBiometricsEnabled';

  BiometricsEnabledNotifier(this._prefs) : super(_prefs?.getBool(_key) ?? false);

  void updateBiometricsEnabled(bool enabled) {
    _prefs?.setBool(_key, enabled);
    state = enabled;
  }
}

final pinHashProvider = StateNotifierProvider<PinHashNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return PinHashNotifier(prefs);
});

class PinHashNotifier extends StateNotifier<String?> {
  final SharedPreferences? _prefs;
  static const _key = 'pinHash';

  PinHashNotifier(this._prefs) : super(_prefs?.getString(_key));

  void updatePinHash(String? hash) {
    if (hash == null) {
      _prefs?.remove(_key);
    } else {
      _prefs?.setString(_key, hash);
    }
    state = hash;
  }
}

final appLockStateProvider = StateNotifierProvider<AppLockNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  final initiallyEnabled = prefs?.getBool('isPinLockEnabled') ?? false;
  return AppLockNotifier(initiallyEnabled);
});

class AppLockNotifier extends StateNotifier<bool> {
  AppLockNotifier(super.initiallyLocked);

  void lock() {
    state = true;
  }

  void unlock() {
    state = false;
  }
}

String hashPin(String pin) {
  final bytes = utf8.encode(pin);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

final syncUrlProvider = StateNotifierProvider<SyncUrlNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return SyncUrlNotifier(prefs);
});

class SyncUrlNotifier extends StateNotifier<String> {
  final SharedPreferences? _prefs;
  static const _key = 'syncUrl';
  SyncUrlNotifier(this._prefs) : super(_prefs?.getString(_key) ?? '');
  void updateSyncUrl(String value) {
    _prefs?.setString(_key, value);
    state = value;
  }
}

final syncTokenProvider = StateNotifierProvider<SyncTokenNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return SyncTokenNotifier(prefs);
});

class SyncTokenNotifier extends StateNotifier<String> {
  final SharedPreferences? _prefs;
  static const _key = 'syncToken';
  SyncTokenNotifier(this._prefs) : super(_prefs?.getString(_key) ?? '');
  void updateSyncToken(String value) {
    _prefs?.setString(_key, value);
    state = value;
  }
}

final isSimulatedSyncProvider = StateNotifierProvider<IsSimulatedSyncNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return IsSimulatedSyncNotifier(prefs);
});

class IsSimulatedSyncNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;
  static const _key = 'isSimulatedSync';
  IsSimulatedSyncNotifier(this._prefs) : super(_prefs?.getBool(_key) ?? true);
  void updateIsSimulatedSync(bool value) {
    _prefs?.setBool(_key, value);
    state = value;
  }
}

final lastSyncTimeProvider = StateNotifierProvider<LastSyncTimeNotifier, DateTime?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return LastSyncTimeNotifier(prefs);
});

class LastSyncTimeNotifier extends StateNotifier<DateTime?> {
  final SharedPreferences? _prefs;
  static const _key = 'lastSyncTime';
  LastSyncTimeNotifier(this._prefs) : super(_prefs?.getString(_key) == null ? null : DateTime.tryParse(_prefs!.getString(_key)!));
  void updateLastSyncTime(DateTime? value) {
    if (value == null) {
      _prefs?.remove(_key);
    } else {
      _prefs?.setString(_key, value.toIso8601String());
    }
    state = value;
  }
}

final lastSelectedAccountIdProvider = StateNotifierProvider<LastSelectedAccountIdNotifier, int?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return LastSelectedAccountIdNotifier(prefs);
});

class LastSelectedAccountIdNotifier extends StateNotifier<int?> {
  final SharedPreferences? _prefs;
  static const _key = 'lastSelectedAccountId';
  LastSelectedAccountIdNotifier(this._prefs) : super(_prefs?.getInt(_key));
  void updateLastSelectedAccountId(int value) {
    _prefs?.setInt(_key, value);
    state = value;
  }
}

final lastSelectedCategoryIdProvider = StateNotifierProvider<LastSelectedCategoryIdNotifier, int?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return LastSelectedCategoryIdNotifier(prefs);
});

class LastSelectedCategoryIdNotifier extends StateNotifier<int?> {
  final SharedPreferences? _prefs;
  static const _key = 'lastSelectedCategoryId';
  LastSelectedCategoryIdNotifier(this._prefs) : super(_prefs?.getInt(_key));
  void updateLastSelectedCategoryId(int value) {
    _prefs?.setInt(_key, value);
    state = value;
  }
}
