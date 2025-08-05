buildscript {
    repositories {
        google()         // ✅ ضروري باش يلقى google-services plugin
        mavenCentral()   // ✅ اختياري ولكن مفيد
    }
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15' // أو آخر نسخة
        // ✅ متوافق مع Firebase SDK
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
