import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseProperties = Properties()
val releasePropertiesFile = rootProject.file("keystore.properties")
if (releasePropertiesFile.exists()) releasePropertiesFile.inputStream().use { releaseProperties.load(it) }

android {
    namespace = "dev.etabli.courrier"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications uses java.time APIs; its AAR uses java.time APIs;
        // minSdk = 24 (< 26) requires core library desugaring on the
        // app module. Caught by the v0.1.0 release-apk CI run; the
        // unit suite (`flutter test`) doesn't exercise this path.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    lint {
        // Analyze libraries with the actual application permissions and API floor.
        checkDependencies = true
    }

    defaultConfig {
        applicationId = "dev.etabli.courrier"
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // OAuth redirect scheme consumed by flutter_appauth at M8.
        // Source of truth: PREFLIGHT.md locked decisions.
        manifestPlaceholders["appAuthRedirectScheme"] = "dev.etabli.courrier"
    }

    signingConfigs {
        if (releasePropertiesFile.exists()) create("production") {
            storeFile = rootProject.file(releaseProperties.getProperty("storeFile"))
            storePassword = releaseProperties.getProperty("storePassword")
            keyAlias = releaseProperties.getProperty("keyAlias")
            keyPassword = releaseProperties.getProperty("keyPassword")
        }
    }
    buildTypes {
        release {
            // Without private signing configuration, produce an unsigned review artifact.
            signingConfig = signingConfigs.findByName("production")
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
