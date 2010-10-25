package spacemule.main

import scala.io.Source
import spacemule.helpers.Converters._
import spacemule.helpers.json.Json

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 13, 2010
 * Time: 11:40:41 AM
 * To change this template use File | Settings | File Templates.
 */

object Main {
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
      println(response.toJson)
    }
  }

  private def dispatchCommand(input: String): Map[String, Any] = {
    return Json.parseMap(input) match {
      case Some(map: Any) =>
        dispatchCommand(map.asInstanceOf[Map[String, Object]])
      case None => Map[String, String]("error" -> "parse_error")
    }
  }

  private def dispatchCommand(input: Map[String, Any]): Map[String, Any] = {
    return input.get("action") match {
      case Some(action: String) => {
        action match {
          case "config" => spacemule.modules.config.Runner.run(input)
          case "find_path" => spacemule.modules.pathfinder.Runner.run(input)
          case "create_players" => spacemule.modules.pmg.Runner.run(input)
        }
      }
      case None => Map[String, String]("error" -> "unknown_action")
    }
  }
}