import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/features/security/data/secure_storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

// Provides the asynchronously loaded PIN hash from secure storage.
final pinHashProvider = StateNotifierProvider<PinHashNotifier, AsyncValue<String?>>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return PinHashNotifier(storage);
});

class PinHashNotifier extends StateNotifier<AsyncValue<String?>> {
  final FlutterSecureStorage _storage;
  static const _key = 'secure_pin_hash';

  PinHashNotifier(this._storage) : super(const AsyncValue.loading()) {
    _loadPin();
  }

  Future<void> _loadPin() async {
    try {
      final pin = await _storage.read(key: _key);
      state = AsyncValue.data(pin);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePinHash(String? hash) async {
    state = const AsyncValue.loading();
    try {
      if (hash == null) {
        await _storage.delete(key: _key);
      } else {
        await _storage.write(key: _key, value: hash);
      }
      state = AsyncValue.data(hash);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// State for whether the app lock is currently engaged
final appLockStateProvider = StateNotifierProvider<AppLockNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData?.value;
  final initiallyEnabled = prefs?.getBool('isPinLockEnabled') ?? false;
  return AppLockNotifier(initiallyEnabled);
});

class AppLockNotifier extends StateNotifier<bool> {
  AppLockNotifier(super.initialState);

  void lock() => state = true;
  void unlock() => state = false;
}
