@file:JvmName("Launcher")

package net.milosvasic.factory.caching

import net.milosvasic.factory.compositeLogger
import net.milosvasic.factory.log
import net.milosvasic.factory.tag
import net.milosvasic.logger.ConsoleLogger
import net.milosvasic.logger.FilesystemLogger
import java.io.File

fun main(args: Array<String>) {

    initLogging()
    log.v("Work in progress")
}

private fun initLogging() {
    tag = BuildInfo.NAME
    val console = ConsoleLogger()
    val filesystem = FilesystemLogger(File("."))
    compositeLogger.addLoggers(console, filesystem)
}
