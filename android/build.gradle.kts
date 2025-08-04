// Inaitwa build.gradle.kts (project level)
plugins {
    id("com.android.application") version "8.7.0" apply false // Hakikisha toleo linafaa
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("com.google.gms.google-services") version "4.4.1" apply false // Ongeza hii
    id("dev.flutter.flutter-gradle-plugin") apply false
}

buildscript {
    extra.apply {
        set("kotlinVersion", "2.0.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
    