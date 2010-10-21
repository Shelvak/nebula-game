package spacemule.main

import scala.io.Source
import scalaj.collection.Imports._
import scala.util.parsing.json.JSON
import scala.util.parsing.json.JSONObject
import scala.util.parsing.json.Parser
import spacemule.modules.pmg.objects.{Player, Galaxy}
import spacemule.persistence.DB
import spacemule.modules.pmg.persistence.Manager

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:40:41 AM
 * To change this template use File | Settings | File Templates.
 */

object Main {
  private val parser = new Parser()

  def main(args: Array[String]) = {
    val reader = Source.fromInputStream(System.in)

    var line: String = null
    while (true) {
      line = reader.bufferedReader.readLine

      // Exit if input is gone
      if (line == null) {
        System.exit(0)
      }

      val response = dispatchCommand(line)
    }
  }

  private def dispatchCommand(input: String): Map[String, Any] = {
    return JSON.parseFull(input) match {
      case Some(map: Map[String, Any]) => dispatchCommand(map)
      case _ => Map[String, String]("error" -> "parse_error")
    }
  }

  private def dispatchCommand(input: Map[String, Any]): Map[String, Any] = {
    return input.get("action") match {
      case Some(action: String) => {
        action match {
          case "config" => spacemule.modules.config.Runner.run(input)
//          case "find_path" => {
//            val javaInput = input.asInstanceOf[Map[String, Object]].asJava
//            val response = spacemule.modules.pathfinder.Runner.run(
//              javaInput
//            )
//            response.asScala.asInstanceOf[Map[String, Any]]
//          }
          case "new_player" => spacemule.modules.pmg.Runner.run(input)
        }
      }
      case None => Map[String, String]("error" -> "unknown_action")
    }
  }
}