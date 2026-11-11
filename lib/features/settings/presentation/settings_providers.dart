import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vittix_wallet/core/database/app_database.dart';
import 'package:vittix_wallet/core/providers/database_provider.dart';
import 'package:vittix_wallet/core/utils/app_logger.dart';
import 'package:vittix_wallet/features/security/data/secure_key_value_store.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;
  static const _themeKey = 'themeMode';

  ThemeModeNotifier(this._prefs)
    : super(
        _prefs == null
            ? ThemeMode.system
            : ThemeMode.values.firstWhere(
                (e) => e.name == _prefs.getString(_themeKey),
                orElse: () => ThemeMode.system,
              ),
      );

  void updateThemeMode(ThemeMode newMode) {
    if (newMode != state) {
      _prefs?.setString(_themeKey, newMode.name);
      state = newMode;
    }
  }
}

// ISO 4217 codes are intentionally uppercase.
// ignore: constant_identifier_names
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

final currencyProvider = StateNotifierProvider<CurrencyNotifier, Currency>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  return CurrencyNotifier(prefs);
});

class CurrencyNotifier extends StateNotifier<Currency> {
  final SharedPreferences? _prefs;
  static const _currencyKey = 'currency';

  CurrencyNotifier(this._prefs)
    : super(
        _prefs == null
            ? Currency.INR
            : Currency.values.byName(
                _prefs.getString(_currencyKey) ?? Currency.INR.name,
              ),
      );

  void updateCurrency(Currency newCurrency) {
    if (newCurrency != state) {
      _prefs?.setString(_currencyKey, newCurrency.name);
      state = newCurrency;
    }
  }

  // Static exchange rates relative to USD (1 USD = X Currency)
  static const _exchangeRates = {
    Currency.USD: 1.0,
    Currency.INR: 83.5,
    Currency.EUR: 0.92,
    Currency.GBP: 0.79,
  };

  double convertToBaseCurrency(double amount, Currency fromCurrency) {
    if (fromCurrency == state) return amount;

    // Convert from -> USD -> Base (state)
    final fromRate = _exchangeRates[fromCurrency]!;
    final baseRate = _exchangeRates[state]!;

    final inUsd = amount / fromRate;
    return inUsd * baseRate;
  }
}

final rolloverModeProvider =
    StateNotifierProvider<RolloverModeNotifier, RolloverMode>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      return RolloverModeNotifier(prefs);
    });

class RolloverModeNotifier extends StateNotifier<RolloverMode> {
  final SharedPreferences? _prefs;
  static const _rolloverKey = 'rolloverMode';

  RolloverModeNotifier(this._prefs)
    : super(
        _prefs == null
            ? RolloverMode.surplusOnly
            : RolloverMode.values.firstWhere(
                (e) => e.name == _prefs.getString(_rolloverKey),
                orElse: () => RolloverMode.surplusOnly,
              ),
      );

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

final pinLockEnabledProvider =
    StateNotifierProvider<PinLockEnabledNotifier, bool>((ref) {
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

final biometricsEnabledProvider =
    StateNotifierProvider<BiometricsEnabledNotifier, bool>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      return BiometricsEnabledNotifier(prefs);
    });

class BiometricsEnabledNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;
  static const _key = 'isBiometricsEnabled';

  BiometricsEnabledNotifier(this._prefs)
    : super(_prefs?.getBool(_key) ?? false);

  void updateBiometricsEnabled(bool enabled) {
    _prefs?.setBool(_key, enabled);
    state = enabled;
  }
}

String hashPin(String pin) {
  const salt = 'vittix_wallet_salt_!@#';
  var bytes = utf8.encode(pin + salt);
  var digest = sha256.convert(bytes);
  for (int i = 0; i < 10000; i++) {
    digest = sha256.convert(digest.bytes);
  }
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

final syncTokenProvider = StateNotifierProvider<SyncTokenNotifier, String>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  final secure = SecureStorageKeyValueStore(ref.watch(secureStorageProvider));
  return SyncTokenNotifier(secure, prefs);
});

/// Loads the sync token from secure storage, migrating the legacy
/// SharedPreferences value once and deleting the old key.
class SyncTokenMigration {
  const SyncTokenMigration._();

  static const key = 'syncToken';

  static Future<String> load({
    required SecureKeyValueStore secure,
    required SharedPreferences? prefs,
  }) async {
    final existing = await secure.read(key);
    if (existing != null && existing.isNotEmpty) return existing;

    final legacy = prefs?.getString(key);
    if (legacy != null && legacy.isNotEmpty) {
      await secure.write(key, legacy);
      await prefs?.remove(key);
      return legacy;
    }
    return '';
  }
}

class SyncTokenNotifier extends StateNotifier<String> {
  SyncTokenNotifier(this._secure, this._prefs) : super('') {
    _load();
  }

  final SecureKeyValueStore _secure;
  final SharedPreferences? _prefs;

  Future<void> _load() async {
    try {
      state = await SyncTokenMigration.load(secure: _secure, prefs: _prefs);
    } on MissingPluginException {
      // No keystore (tests/unsupported platform): there is no token to load.
    } on PlatformException {
      // Keystore unavailable: treat it as no token rather than crashing sync.
    }
  }

  Future<void> updateSyncToken(String value) async {
    await _secure.write(SyncTokenMigration.key, value);
    state = value;
  }
}

/// User-set passphrase used to encrypt the sync payload at rest in transit.
/// Stored in the platform keystore, never in SharedPreferences.
final syncPassphraseProvider =
    StateNotifierProvider<SyncPassphraseNotifier, String>((ref) {
      return SyncPassphraseNotifier(ref.watch(secureStorageProvider));
    });

class SyncPassphraseNotifier extends StateNotifier<String> {
  SyncPassphraseNotifier(this._storage) : super('') {
    _load();
  }

  final FlutterSecureStorage _storage;
  static const _key = 'syncPassphrase';

  Future<void> _load() async {
    try {
      state = await _storage.read(key: _key) ?? '';
    } on MissingPluginException {
      // No keystore: sync stays unencrypted until a passphrase can be stored.
    } on PlatformException {
      // Keystore unavailable: same as above.
    }
  }

  Future<void> updatePassphrase(String value) async {
    await _storage.write(key: _key, value: value);
    state = value;
  }
}

final nextcloudUsernameProvider =
    StateNotifierProvider<NextcloudUsernameNotifier, String>((ref) {
      final secureStorage = ref.watch(secureStorageProvider);
      return NextcloudUsernameNotifier(secureStorage);
    });

class NextcloudUsernameNotifier extends StateNotifier<String> {
  final FlutterSecureStorage _storage;
  static const _key = 'nextcloudUsername';
  NextcloudUsernameNotifier(this._storage) : super('') {
    _load();
  }
  Future<void> _load() async {
    state = await _storage.read(key: _key) ?? '';
  }

  Future<void> updateUsername(String value) async {
    await _storage.write(key: _key, value: value);
    state = value;
  }
}

final nextcloudPasswordProvider =
    StateNotifierProvider<NextcloudPasswordNotifier, String>((ref) {
      final secureStorage = ref.watch(secureStorageProvider);
      return NextcloudPasswordNotifier(secureStorage);
    });

class NextcloudPasswordNotifier extends StateNotifier<String> {
  final FlutterSecureStorage _storage;
  static const _key = 'nextcloudPassword';
  NextcloudPasswordNotifier(this._storage) : super('') {
    _load();
  }
  Future<void> _load() async {
    state = await _storage.read(key: _key) ?? '';
  }

  Future<void> updatePassword(String value) async {
    await _storage.write(key: _key, value: value);
    state = value;
  }
}

final isSimulatedSyncProvider =
    StateNotifierProvider<IsSimulatedSyncNotifier, bool>((ref) {
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

final lastSyncTimeProvider =
    StateNotifierProvider<LastSyncTimeNotifier, DateTime?>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      return LastSyncTimeNotifier(prefs);
    });

class LastSyncTimeNotifier extends StateNotifier<DateTime?> {
  final SharedPreferences? _prefs;
  static const _key = 'lastSyncTime';
  LastSyncTimeNotifier(this._prefs)
    : super(
        _prefs?.getString(_key) == null
            ? null
            : DateTime.tryParse(_prefs!.getString(_key)!),
      );
  void updateLastSyncTime(DateTime? value) {
    if (value == null) {
      _prefs?.remove(_key);
    } else {
      _prefs?.setString(_key, value.toIso8601String());
    }
    state = value;
  }
}

final lastSelectedAccountIdProvider =
    StateNotifierProvider<LastSelectedAccountIdNotifier, int?>((ref) {
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

final lastSelectedCategoryIdProvider =
    StateNotifierProvider<LastSelectedCategoryIdNotifier, int?>((ref) {
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

final currentWalletIdProvider =
    StateNotifierProvider<CurrentWalletIdNotifier, int>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      final walletDao = ref.watch(walletDaoProvider);
      return CurrentWalletIdNotifier(prefs, walletDao);
    });

class CurrentWalletIdNotifier extends StateNotifier<int> {
  final SharedPreferences? _prefs;
  final WalletDao? _walletDao;
  static const _key = 'currentWalletId';

  CurrentWalletIdNotifier(this._prefs, [this._walletDao])
    : super(_prefs?.getInt(_key) ?? 1) {
    _validateAndRestore();
  }

  Future<void> _validateAndRestore({int? actorAccountId}) async {
    if (_walletDao == null) return;
    try {
      final storedId = _prefs?.getInt(_key);
      final validId = await _walletDao.validateActiveWallet(
        storedId,
        actorAccountId: actorAccountId,
      );
      if (!mounted) return;
      if (validId != null) {
        if (state != validId) {
          state = validId;
        }
        await _prefs?.setInt(_key, validId);
      } else {
        await _prefs?.remove(_key);
        if (mounted) state = 0;
      }
    } on Object catch (error, stackTrace) {
      // Keep the current wallet on a transient failure (including the database
      // being closed during teardown); never crash startup.
      AppLogger.warn('Active wallet revalidation failed', error, stackTrace);
    }
  }

  Future<bool> selectWallet(int value, {int? actorAccountId}) async {
    final walletDao = _walletDao;
    if (walletDao != null) {
      final isValid = await walletDao.isWalletValid(
        value,
        actorAccountId: actorAccountId,
      );
      if (!isValid) {
        // Rejecting the switch preserves the previous valid wallet instead of
        // moving the app into a wallet context the actor cannot access.
        throw InvalidActiveWalletException(
          'Cannot switch to wallet $value: it does not exist or the actor has '
          'no active membership.',
        );
      }
    }
    await _prefs?.setInt(_key, value);
    state = value;
    return true;
  }

  Future<void> revalidate({int? actorAccountId}) async {
    await _validateAndRestore(actorAccountId: actorAccountId);
  }

  void forceSetStateForTest(int value) {
    state = value;
  }
}

final availableWalletsProvider = StreamProvider<List<Wallet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.wallets).watch();
});

final currentWalletProvider = StreamProvider<Wallet?>((ref) {
  final db = ref.watch(databaseProvider);
  final id = ref.watch(currentWalletIdProvider);
  return (db.select(
    db.wallets,
  )..where((w) => w.id.equals(id))).watchSingleOrNull();
});

final dashboardWidgetsOrderProvider =
    StateNotifierProvider<DashboardWidgetsOrderNotifier, List<String>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      return DashboardWidgetsOrderNotifier(prefs);
    });

class DashboardWidgetsOrderNotifier extends StateNotifier<List<String>> {
  final SharedPreferences? _prefs;
  static const _key = 'dashboardWidgetsOrder';
  DashboardWidgetsOrderNotifier(this._prefs)
    : super(
        _prefs?.getStringList(_key) ??
            ['accounts', 'budgets', 'debts', 'spending', 'recent'],
      );

  void updateOrder(List<String> newOrder) {
    _prefs?.setStringList(_key, newOrder);
    state = newOrder;
  }
}

final dashboardWidgetsHiddenProvider =
    StateNotifierProvider<DashboardWidgetsHiddenNotifier, Map<String, bool>>((
      ref,
    ) {
      final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
      return DashboardWidgetsHiddenNotifier(prefs);
    });

class DashboardWidgetsHiddenNotifier extends StateNotifier<Map<String, bool>> {
  final SharedPreferences? _prefs;
  static const _key = 'dashboardWidgetsHidden';
  DashboardWidgetsHiddenNotifier(this._prefs) : super(_loadInitial(_prefs));

  static Map<String, bool> _loadInitial(SharedPreferences? prefs) {
    if (prefs == null) return {};
    final str = prefs.getString(_key);
    if (str != null) {
      try {
        return Map<String, bool>.from(jsonDecode(str) as Map);
      } on FormatException catch (error) {
        AppLogger.warn(
          'Invalid dashboard widget settings; using defaults',
          error,
        );
      } on TypeError catch (error) {
        AppLogger.warn(
          'Invalid dashboard widget settings; using defaults',
          error,
        );
      }
    }
    return {};
  }

  void toggleWidget(String id, bool isHidden) {
    final newState = {...state, id: isHidden};
    _prefs?.setString(_key, jsonEncode(newState));
    state = newState;
  }
}
