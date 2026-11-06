import java.io.File
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing material is deliberately NOT checked in. Copy
// android/key.properties.example to android/key.properties and point storeFile
// at your keystore. Release builds fail fast with a clear message when it is
// missing or incomplete.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
val hasKeystoreProperties = keystorePropertiesFile.exists()
if (hasKeystoreProperties) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

// SMS import is optional. Set `vittix.smsImport=false` (android/gradle.properties,
// ORG_GRADLE_PROJECT_vittix.smsImport, or -Pvittix.smsImport=false) to build an
// APK/AAB that declares no SMS permissions and registers no SMS receiver. Pair
// it with --dart-define=SMS_IMPORT_ENABLED=false so the UI entry point is hidden.
val smsImportEnabled = (project.findProperty("vittix.smsImport") ?: "true")
    .toString()
    .toBoolean()

val requiredKeystoreKeys = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
val missingKeystoreKeys = requiredKeystoreKeys.filter {
    keystoreProperties.getProperty(it).isNullOrBlank()
}
val releaseSigningReady = hasKeystoreProperties && missingKeystoreKeys.isEmpty()

android {
    namespace = "com.vittix.wallet"
    // Use a minimum of 36 to satisfy plugin requirements (e.g. file_picker).
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.vittix.wallet"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (releaseSigningReady) {
            create("release") {
                val storePath = keystoreProperties.getProperty("storeFile")
                storeFile = if (File(storePath).isAbsolute) {
                    File(storePath)
                } else {
                    // Paths in key.properties are relative to the android/ directory.
                    rootProject.file(storePath)
                }
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            if (releaseSigningReady) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

// When SMS import is disabled, merge an overlay manifest that removes the SMS
// permissions contributed by this app and by android_sms_reader, and removes
// the capture receiver.
androidComponents {
    onVariants { variant ->
        if (!smsImportEnabled) {
            variant.sources.manifests?.addStaticManifestFile(
                "src/noSms/AndroidManifest.xml",
            )
        }
    }
}

// Fail only when a release build is actually requested, so debug builds and
// `flutter test` keep working on machines without signing material.
gradle.taskGraph.whenReady {
    val releaseRequested = allTasks.any { task ->
        val name = task.name
        (name.contains("Release")) &&
            (name.startsWith("assemble") || name.startsWith("bundle") || name.startsWith("package"))
    }
    if (releaseRequested && !releaseSigningReady) {
        val reason = if (!hasKeystoreProperties) {
            "android/key.properties does not exist"
        } else {
            "android/key.properties is missing: ${missingKeystoreKeys.joinToString(", ")}"
        }
        throw GradleException(
            "Refusing to build a release APK/AAB: $reason.\n" +
                "Copy android/key.properties.example to android/key.properties and fill in " +
                "storeFile, storePassword, keyAlias and keyPassword."
        )
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}

flutter {
    source = "../.."
}
