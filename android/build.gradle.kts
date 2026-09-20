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

// A3: the sqlcipher_flutter_libs module still declares an old compileSdk, which
// trips the AAR-metadata check against this project's modern androidx
// dependencies. Force plugin modules onto a current compileSdk.
// Reflection keeps this independent of the AGP class API version.
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android") ?: return@afterEvaluate
        try {
            androidExtension.javaClass
                .getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                .invoke(androidExtension, 36)
        } catch (_: Exception) {
            try {
                androidExtension.javaClass
                    .getMethod("setCompileSdk", Int::class.javaObjectType)
                    .invoke(androidExtension, 36)
            } catch (_: Exception) {
                // Leave the module's own setting if neither signature exists.
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
