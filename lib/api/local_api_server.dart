// BROKEN DEPENDENCY: Experimental
/*
import 'dart:io';
import 'package:alfred/alfred.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/api/web_dashboard_ui.dart';

class LocalApiServer {
  final AppDatabase database;
  final int Function() getCurrentWalletId;
  final void Function(int) setCurrentWalletId;
  Alfred? _app;

  LocalApiServer(this.database, this.getCurrentWalletId, this.setCurrentWalletId);

  Future<void> start({int port = 8080}) async {
    if (_app != null) return; // Already running

    _app = Alfred();

    // CORS middleware
    _app!.all('*', (req, res) {
      res.headers.add('Access-Control-Allow-Origin', '*');
      res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
      res.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      if (req.method == 'OPTIONS') {
        res.close();
      }
    });

    _app!.get('/', (req, res) {
      res.headers.contentType = ContentType.html;
      return WebDashboardUI.htmlContent;
    });

    _app!.get('/api/accounts', (req, res) async {
      try {
        final walletId = getCurrentWalletId();
        final accounts = await (database.select(database.accounts)..where((a) => a.walletId.equals(walletId))).get();
        return accounts.map((a) => a.toJson()).toList();
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.get('/api/transactions', (req, res) async {
      try {
        final walletId = getCurrentWalletId();
        final transactions = await (database.select(database.transactions)..where((t) => t.walletId.equals(walletId))).get();
        return transactions.map((t) => t.toJson()).toList();
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.post('/api/transactions', (req, res) async {
      try {
        final body = await req.bodyAsJsonMap;
        final walletId = getCurrentWalletId();
        final transaction = TransactionsCompanion.insert(
          walletId: drift.Value(walletId),
          amount: double.tryParse(body['amount'].toString()) ?? 0.0,
          date: DateTime.parse(body['date']),
          type: TransactionType.values.byName(body['type']),
          categoryId: body['categoryId'] as int,
          accountId: body['accountId'] as int,
          note: drift.Value(body['note']?.toString()),
        );
        final id = await database.into(database.transactions).insert(transaction);
        return {'success': true, 'id': id};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.put('/api/transactions/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        final body = await req.bodyAsJsonMap;
        final walletId = getCurrentWalletId();
        
        // Ensure the transaction belongs to the current wallet
        final existing = await (database.select(database.transactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).getSingleOrNull();
        if (existing == null) {
           res.statusCode = 404;
           return {'error': 'Transaction not found in current wallet'};
        }

        final update = TransactionsCompanion(
          amount: drift.Value(double.tryParse(body['amount'].toString()) ?? 0.0),
          date: drift.Value(DateTime.parse(body['date'])),
          type: drift.Value(TransactionType.values.byName(body['type'])),
          categoryId: drift.Value(body['categoryId'] as int),
          accountId: drift.Value(body['accountId'] as int),
          note: drift.Value(body['note']?.toString()),
        );
        await (database.update(database.transactions)..where((t) => t.id.equals(id))).write(update);
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.delete('/api/transactions/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        final walletId = getCurrentWalletId();
        // Ensure wallet boundary
        await (database.delete(database.transactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).go();
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.get('/api/categories', (req, res) async {
      try {
        final categories = await database.select(database.categories).get();
        return categories.map((c) => c.toJson()).toList();
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.get('/api/wallets', (req, res) async {
      try {
        final wallets = await database.select(database.wallets).get();
        return {
          'currentWalletId': getCurrentWalletId(),
          'wallets': wallets.map((w) => w.toJson()).toList()
        };
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.post('/api/wallet/switch', (req, res) async {
      try {
        final body = await req.bodyAsJsonMap;
        final id = body['id'] as int;
        setCurrentWalletId(id);
        return {'success': true, 'currentWalletId': id};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.post('/api/accounts', (req, res) async {
      try {
        final body = await req.bodyAsJsonMap;
        final walletId = getCurrentWalletId();
        final account = AccountsCompanion.insert(
          walletId: drift.Value(walletId),
          name: body['name'],
          type: AccountType.values.byName(body['type']),
          icon: body['icon'] ?? 58136, // default icon
          color: body['color'] ?? 'FF3B82F6', // default color
          openingBalance: drift.Value(double.tryParse(body['openingBalance'].toString()) ?? 0.0),
          
        );
        final id = await database.into(database.accounts).insert(account);
        return {'success': true, 'id': id};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.put('/api/accounts/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        final body = await req.bodyAsJsonMap;
        final walletId = getCurrentWalletId();
        
        final existing = await (database.select(database.accounts)..where((a) => a.id.equals(id) & a.walletId.equals(walletId))).getSingleOrNull();
        if (existing == null) {
           res.statusCode = 404;
           return {'error': 'Account not found'};
        }

        final update = AccountsCompanion(
          name: drift.Value(body['name']),
          type: drift.Value(AccountType.values.byName(body['type'])),
          openingBalance: drift.Value(double.tryParse(body['openingBalance'].toString()) ?? 0.0),
          
        );
        await (database.update(database.accounts)..where((a) => a.id.equals(id))).write(update);
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.delete('/api/accounts/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        await (database.delete(database.accounts)..where((a) => a.id.equals(id))).go();
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.post('/api/categories', (req, res) async {
      try {
        final body = await req.bodyAsJsonMap;
        final category = CategoriesCompanion.insert(
          name: body['name'],
          icon: body['icon'] ?? 58136,
          color: body['color'] ?? 'FF10B981',
        );
        final id = await database.into(database.categories).insert(category);
        return {'success': true, 'id': id};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.put('/api/categories/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        final body = await req.bodyAsJsonMap;
        
        final existing = await (database.select(database.categories)..where((c) => c.id.equals(id))).getSingleOrNull();
        if (existing == null) {
           res.statusCode = 404;
           return {'error': 'Category not found'};
        }

        final update = CategoriesCompanion(
          name: drift.Value(body['name']),
        );
        await (database.update(database.categories)..where((c) => c.id.equals(id))).write(update);
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    _app!.delete('/api/categories/:id', (req, res) async {
      try {
        final id = int.parse(req.params['id']);
        await (database.delete(database.categories)..where((c) => c.id.equals(id))).go();
        return {'success': true};
      } catch (e) {
        res.statusCode = 500;
        return {'error': e.toString()};
      }
    });

    try {
      await _app!.listen(port);
      debugPrint('Local API server listening on port $port');
    } catch (e) {
      debugPrint('Failed to start server: $e');
      _app = null;
    }
  }

  Future<void> stop() async {
    if (_app != null) {
      await _app!.close();
      _app = null;
      debugPrint('Local API server stopped');
    }
  }

  bool get isRunning => _app != null;
}

*/