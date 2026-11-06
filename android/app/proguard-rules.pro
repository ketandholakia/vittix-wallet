# ML Kit text recognition ships optional/unreferenced classes that R8 cannot
# see; keep the whole namespace so recognition does not crash in release.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# SQLCipher (if used through its Java bindings) and the sqflite plugin touch
# classes reflectively / from native code.
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }
-dontwarn net.sqlcipher.**
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# Application components referenced from the manifest.
-keep class com.vittix.wallet.** { *; }
