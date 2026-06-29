allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Force every plugin subproject onto a compileSdk that satisfies the
// floor set by the newest androidx transitives (exifinterface 1.4.1
// requires 34+). Flutter plugins that pin themselves to compileSdk 33
// (flutter_appauth 9.x, others) fail the AAR metadata gate otherwise.
// compileSdk only changes which APIs are visible at compile time —
// runtime behavior is governed by each module's targetSdk, untouched.
// Must register BEFORE the evaluationDependsOn block below: that
// block triggers subproject evaluation, after which afterEvaluate
// hooks can no longer be registered.
subprojects {
    afterEvaluate {
        extensions.findByName("android")?.let { ext ->
            (ext as com.android.build.gradle.BaseExtension).compileSdkVersion(36)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
