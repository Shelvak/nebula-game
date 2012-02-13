import sbt._
import Keys._

object SpaceMule extends Build {
  lazy val dist = TaskKey[Unit](
    "dist", "Copies files from target to dist and appends libraries."
  )
  lazy val distTask =
    dist <<= (
      name, scalaVersion, version, update, crossTarget,
      packageBin in Compile
    ).map {
      case (projectName, scalaVersion, projectVersion, updateReport, out, _) =>
        val dist = (out / ".." / ".." / "dist").getAbsoluteFile
        // Clean up dist dir.
        IO.delete(dist)

        // Copy packaged jar.
        IO.copyFile(
          out / "%s_%s-%s.jar".format(
            projectName.toLowerCase, scalaVersion, projectVersion
          ),
          dist / "%s.jar".format(projectName)
        )

        // Copy libs.
        updateReport.allFiles.foreach { srcPath =>
          val destPath = dist / "lib" / srcPath.getName
          IO.copyFile(srcPath, destPath, preserveLastModified=true)
        }
    }

  lazy val spaceMule = Project(
    "SpaceMule",
    file("."),
    settings =
      Defaults.defaultSettings ++
      Seq(
        name                := "SpaceMule",
        organization        := "com.tinylabproductions",
        version             := "1.0",
        scalaVersion        := "2.9.1",
        scalacOptions       := Seq("-deprecation"),
        resolvers           := Seq(
          // JGraphT
          "conjars.org" at "http://conjars.org/repo"
        ),
        libraryDependencies := Seq(
          // Java libraries

          // Evaluation of the formulas
          "de.congrace" % "exp4j" % "0.2.9",

          // MySQL connector
          "mysql" % "mysql-connector-java" % "5.1.17",
          // Apache Commons IO
          "commons-io" % "commons-io" % "2.0.1",
          // Graph library
          "thirdparty" % "jgrapht-jdk1.6" % "0.8.2",

          // Scala libraries

          // Converting between Java and Scala collections
          "org.scalaj" %% "scalaj-collection" % "1.2"
        ),
        distTask
      )
  )
}