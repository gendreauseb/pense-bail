import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Clé de publication (envoi au Play Store) : android/key.properties, hors du
// dépôt, pointe vers un keystore rangé hors du dépôt. Voir
// docs/publication/README.md.
val proprietesCle = Properties().apply {
    val fichier = rootProject.file("key.properties")
    if (fichier.exists()) fichier.inputStream().use { load(it) }
}

// Build de test fermé (--dart-define=BETA=true) : son numéro de version doit
// contenir « beta », pour ne jamais le confondre avec la version publique
// dans la Play Console (l'interrupteur Premium y serait offert à tous).
val estBeta = (project.findProperty("dart-defines") as String?)
    ?.split(",")
    ?.any { String(Base64.getDecoder().decode(it)) == "BETA=true" } == true

android {
    namespace = "fr.pensebail.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Requis par flutter_local_notifications (rappels programmés).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "fr.pensebail.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("publication") {
            if (!proprietesCle.isEmpty) {
                storeFile = file(proprietesCle.getProperty("storeFile"))
                storePassword = proprietesCle.getProperty("storePassword")
                keyAlias = proprietesCle.getProperty("keyAlias")
                keyPassword = proprietesCle.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Jamais la clé de debug : le Play Store la refuse.
            signingConfig = signingConfigs.getByName("publication")
        }
    }
}

// Contrôles avant tout build de publication (APK ou bundle), avant que la
// moindre tâche ne s'exécute.
gradle.taskGraph.whenReady {
    val publication = allTasks.any {
        it.project == project &&
            (it.name == "assembleRelease" || it.name == "bundleRelease")
    }
    if (!publication) return@whenReady
    if (proprietesCle.isEmpty) {
        throw GradleException(
            "android/key.properties introuvable : impossible de signer la " +
                "version de publication. Voir docs/publication/README.md.",
        )
    }
    val version = flutter.versionName ?: ""
    if (estBeta && !version.contains("beta")) {
        throw GradleException(
            "Build bêta ($version) : ajoutez « beta » au numéro de version, " +
                "par exemple --build-name=1.0.0-beta.1.",
        )
    }
    if (!estBeta && version.contains("beta")) {
        throw GradleException(
            "Version $version sans --dart-define=BETA=true : retirez « beta » " +
                "du numéro de version de la version publique.",
        )
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
