@file:JvmName("Launcher")

package net.milosvasic.factory.proxy.caching.application

import net.milosvasic.factory.*
import net.milosvasic.factory.validation.Validator
import net.milosvasic.factory.validation.parameters.ArgumentsExpectedException
import net.milosvasic.logger.ConsoleLogger
import net.milosvasic.logger.FilesystemLogger
import java.io.File

fun main(args: Array<String>) {

    tag = BuildInfo.versionName
    val consoleLogger = ConsoleLogger()
    val here = File(FILE_LOCATION_HERE)
    val filesystemLogger = FilesystemLogger(here)
    compositeLogger.addLoggers(consoleLogger, filesystemLogger)

    // TODO: OS init(s)
    try {

        Validator.Arguments.validateNotEmpty(*args)
        val file = File(args[0])

        val lofFilenameSuffix = file.name.replace(file.extension, "").replace(".", "") +
                "_" + System.currentTimeMillis()

        filesystemLogger.setFilenameSuffix(lofFilenameSuffix)

        if (file.exists()) {
            log.v("Work in progress")
            // TODO:

        } else {

            val msg = "Configuration file does not exist: ${file.absolutePath}"
            val error = IllegalArgumentException(msg)
            fail(error)
        }
    } catch (e: ArgumentsExpectedException) {

        fail(e)
    }
}
