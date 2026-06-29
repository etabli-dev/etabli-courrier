plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.etabli.courrier"
    // Pinned to 36: `flutter.compileSdkVersion` resolves to 33 on this
    // Flutter channel and several androidx transitives (exifinterface
    // 1.4.1 via local_auth/image_picker, core 1.16 via flutter_appauth)
    // now require compileSdk >= 34. 36 is the current latest stable;
    // safe because compileSdk only sets which APIs are visible at
    // compile-time — targetSdk = flutter.targetSdkVersion remains the
    // runtime-behavior switch and is unchanged.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications v20's AAR uses java.time APIs;
        // minSdk = 24 (< 26) requires core library desugaring on the
        // app module. Caught by the v0.1.0 release-apk CI run; the
        // unit suite (`flutter test`) doesn't exercise this path.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "dev.etabli.courrier"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // OAuth redirect scheme consumed by flutter_appauth at M8.
        // Source of truth: PREFLIGHT.md locked decisions.
        manifestPlaceholders["appAuthRedirectScheme"] = "dev.etabli.courrier"
    }

    buildTypes {
        release {
            // Debug signing for `flutter run --release`; release signing wired at M15.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
