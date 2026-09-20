import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Loads the SQLCipher build of sqlite3 rather than the plain library.
///
/// Top-level so it can also be referenced from background isolates.
DynamicLibrary openCipherOnAndroid() => DynamicLibrary.open('libsqlcipher.so');

/// Installs the SQLCipher loader for this platform.
///
/// Deliberately uses no platform channels, so it is safe to call from the
/// database's background isolate as well as from `main`. `open` is per-isolate,
/// so the override has to be applied in every isolate that opens a database.
void useSqlCipher() {
  if (Platform.isAndroid) {
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }
}
