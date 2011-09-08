import sbt._
import Keys._

object SpaceMule extends Build {
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

          // MySQL connector
          "mysql" % "mysql-connector-java" % "5.1.17",
          // JSON parsing/generation
          "com.googlecode.json-simple" % "json-simple" % "1.1",
          // Evaluation of the formulas
          "net.java.dev.eval" % "eval" % "0.5",
          // Apache Commons IO
          "commons-io" % "commons-io" % "2.0.1",
          // Graph library
          "thirdparty" % "jgrapht-jdk1.6" % "0.8.2",

          // Scala libraries

          // Converting between Java and Scala collections
          "org.scalaj" %% "scalaj-collection" % "1.2"
        )
      )
  )
}