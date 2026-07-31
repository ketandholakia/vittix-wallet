import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/api/local_api_server.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';

final localApiServerProvider = Provider<LocalApiServer>((ref) {
  final db = ref.watch(databaseProvider);
  return LocalApiServer(
    db, 
    () => ref.read(currentWalletIdProvider),
    (int id) => ref.read(currentWalletIdProvider.notifier).selectWallet(id),
  );
});

final apiServerStateProvider = StateNotifierProvider<ApiServerStateNotifier, ApiServerState>((ref) {
  final server = ref.watch(localApiServerProvider);
  return ApiServerStateNotifier(server);
});

class ApiServerState {
  final bool isRunning;
  final String? ipAddress;
  final int port;

  ApiServerState({
    required this.isRunning,
    this.ipAddress,
    required this.port,
  });
}

class ApiServerStateNotifier extends StateNotifier<ApiServerState> {
  final LocalApiServer _server;

  ApiServerStateNotifier(this._server)
      : super(ApiServerState(isRunning: false, port: 8080));

  Future<void> startServer() async {
    if (state.isRunning) return;

    await _server.start(port: state.port);
    final ip = await _getLocalIpAddress();

    state = ApiServerState(
      isRunning: true,
      ipAddress: ip,
      port: state.port,
    );
  }

  Future<void> stopServer() async {
    if (!state.isRunning) return;

    await _server.stop();
    state = ApiServerState(
      isRunning: false,
      ipAddress: null,
      port: state.port,
    );
  }

  Future<String?> _getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (!addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      // Ignore
    }
    return null;
  }
}
