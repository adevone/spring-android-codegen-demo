buildscript {
    val kotlinVersion = "1.3.71"
    val atomicfuVersion = "0.14.2"

    repositories {
        mavenCentral()
        jcenter()
        maven(url = "https://kotlin.bintray.com/kotlinx")
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("org.jetbrains.kotlin:kotlin-serialization:$kotlinVersion")
        classpath("org.jetbrains.kotlinx:atomicfu-gradle-plugin:$atomicfuVersion")
    }
}

plugins {
    val kotlinVersion = "1.3.71"
    kotlin("multiplatform")
    id("kotlinx-serialization") version kotlinVersion
    id("maven-publish")
}

repositories {
    mavenCentral()
    jcenter()
    maven(url = "https://oss.sonatype.org/content/repositories/snapshots")
    maven(url = "https://kotlin.bintray.com/kotlinx")
}

kotlin {
    jvm()
    //iosArm64  {
    //    binaries {
    //        framework()
    //    }
    //    compilations.forEach { compilation ->
    //        compilation.kotlinOptions.freeCompilerArgs += "-Xobjc-generics"
    //    }
    //}
    //iosX64  {
    //    binaries {
    //        framework()
    //    }
    //    compilations.forEach { compilation ->
    //        compilation.kotlinOptions.freeCompilerArgs += "-Xobjc-generics"
    //    }
    //}
    //js()

    val ktorVersion = "1.3.2"
    val coroutinesVersion = "1.3.4"
    val kodeinVersion = "6.5.3"
    val serializationVersion = "0.20.0"
    val kotlinVersion = "1.3.70"
    val atomicfuVersion = "0.14.2"
    val klockVersion = "1.10.0"

    sourceSets {
        getByName("commonMain") {
            dependencies {
                implementation("org.jetbrains.kotlin:kotlin-stdlib-common:$kotlinVersion")
                implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime-common:$serializationVersion")
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutinesVersion")

                implementation("com.soywiz.korlibs.klock:klock:$klockVersion")

                implementation("org.kodein.di:kodein-di-erased:$kodeinVersion")

                implementation("org.jetbrains.kotlinx:atomicfu:$atomicfuVersion")

                implementation("io.ktor:ktor-client-core:$ktorVersion")
            }
        }
        getByName("jvmMain"){
            dependencies {
                implementation(kotlin("stdlib"))
                implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime:$serializationVersion")
                implementation("io.ktor:ktor-client-core-jvm:$ktorVersion")

            }
        }
        //getByName("jsMain"){
        //    dependencies {
        //        implementation(kotlin("stdlib-js"))
        //        implementation("io.ktor:ktor-client-core-js:$ktorVersion")
        //        implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime-js:$serializationVersion")
        //        implementation("org.kodein.di:kodein-di-erased-js:$kodeinVersion")
        //    }
        //}
        //getByName("iosArm64Main"){
        //    dependencies {
        //        implementation("io.ktor:ktor-client-core-native:$ktorVersion")
        //        implementation("org.jetbrains.kotlinx:kotlinx-serialization-runtime-native:$serializationVersion")
        //    }
        //}

        //getByName("iosX64Main").dependsOn(getByName("iosArm64Main"))
    }
}

group = "io.swagger"
version = "0.1"

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

//publishing {
//    repositories {
//        maven {
//            url = uri(project.extra["REPO_URL"].toString() + "/" + project.extra["REPO_KEY"].toString())
//            credentials {
//                username = project.extra["REPO_USERNAME"].toString()
//                password = project.extra["REPO_ENCRYPTED_PASSWORD"].toString()
//            }
//        }
//    }
//}