plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Google Services plugin
}

android {
    namespace = "com.example.projectfrontend"
    compileSdk = 34  // Updated to latest stable version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.projectfrontend"
        minSdk = 23
        targetSdk = 34  // Updated to match compileSdk
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
        
        // NDK version can be managed by AGP, but you can specify if needed
        ndkVersion = "27.0.12077973"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// build.gradle.kts (Kotlin Script)
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    
    // Add other Firebase dependencies you might need
    // implementation("com.google.firebase:firebase-auth-ktx")
    // implementation("com.google.firebase:firebase-firestore-ktx")
}