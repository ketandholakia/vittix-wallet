import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/services/auto_backup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings for automatic backups: enable, interval, target folder and whether
/// the backups are encrypted with a stored passphrase.
class AutoBackupScreen extends ConsumerStatefulWidget {
  const AutoBackupScreen({super.key});

  @override
  ConsumerState<AutoBackupScreen> createState() => _AutoBackupScreenState();
}

class _AutoBackupScreenState extends ConsumerState<AutoBackupScreen> {
  SharedPreferences? _prefs;
  AutoBackupSettings _settings = const AutoBackupSettings();
  final _passphraseController = TextEditingController();
  bool _hasStoredPassphrase = false;
  bool _busy = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = await ref.read(autoBackupServiceProvider).readPassphrase();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _settings = AutoBackupSettings.load(prefs);
      _hasStoredPassphrase = stored != null && stored.isNotEmpty;
    });
  }

  Future<void> _update(AutoBackupSettings next) async {
    final prefs = _prefs;
    if (prefs == null) return;
    setState(() => _settings = next);
    await next.save(prefs);
  }

  Future<void> _pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    await _update(_settings.copyWith(directoryPath: path));
  }

  Future<void> _savePassphrase() async {
    final value = _passphraseController.text;
    if (value.isEmpty) {
      setState(() => _status = 'Enter a passphrase first.');
      return;
    }
    await AutoBackupService.setPassphrase(value);
    if (!mounted) return;
    setState(() {
      _hasStoredPassphrase = true;
      _passphraseController.clear();
      _status = 'Passphrase saved to secure storage.';
    });
  }

  Future<void> _runNow() async {
    final prefs = _prefs;
    if (prefs == null) return;
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final file = await ref.read(autoBackupServiceProvider).runIfDue(
            // Ignore the interval for a manual run.
            settings: _settings.copyWith(enabled: true, intervalDays: 0),
            prefs: prefs,
          );
      if (!mounted) return;
      setState(() {
        _status = file == null
            ? 'Nothing written. Pick a folder first (and a passphrase if encrypting).'
            : 'Backup written: ${file.path}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Backup failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canEncrypt = _hasStoredPassphrase || _passphraseController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Automatic Backup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Schedule', style: textTheme.titleMedium),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Back up automatically'),
            subtitle: const Text(
              'Writes a snapshot when the app starts, at most once per interval.',
            ),
            value: _settings.enabled,
            onChanged: (v) => _update(_settings.copyWith(enabled: v)),
          ),
          DropdownButtonFormField<int>(
            initialValue: _settings.intervalDays,
            decoration: const InputDecoration(
              labelText: 'Interval',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Every day')),
              DropdownMenuItem(value: 3, child: Text('Every 3 days')),
              DropdownMenuItem(value: 7, child: Text('Every 7 days')),
              DropdownMenuItem(value: 30, child: Text('Every 30 days')),
            ],
            onChanged: (v) => v == null
                ? null
                : _update(_settings.copyWith(intervalDays: v)),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Backup folder'),
            subtitle: Text(_settings.directoryPath ?? 'Not set - tap to choose'),
            onTap: _pickFolder,
          ),
          const Divider(height: 32),
          Text('Encryption', style: textTheme.titleMedium),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Encrypt backups'),
            subtitle: Text(
              canEncrypt
                  ? 'AES-256-GCM with your stored passphrase.'
                  : 'Set a passphrase below first.',
            ),
            value: _settings.encrypt,
            onChanged: canEncrypt
                ? (v) => _update(_settings.copyWith(encrypt: v))
                : null,
          ),
          TextField(
            controller: _passphraseController,
            obscureText: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: _hasStoredPassphrase
                  ? 'Passphrase (replace existing)'
                  : 'Passphrase',
              helperText: 'Stored in the platform keystore, not in the database.',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _savePassphrase,
            icon: const Icon(Icons.key),
            label: const Text('Save passphrase'),
          ),
          const Divider(height: 32),
          FilledButton.icon(
            onPressed: _busy ? null : _runNow,
            icon: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.backup_outlined),
            label: const Text('Back up now'),
          ),
          if (_status != null) ...[
            const SizedBox(height: 12),
            Text(_status!, style: textTheme.bodySmall),
          ],
          const SizedBox(height: 24),
          Text(
            'Only the 5 most recent backups are kept in the folder.',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
