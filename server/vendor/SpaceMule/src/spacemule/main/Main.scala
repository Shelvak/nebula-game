package spacemule.main

import java.util.Locale
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
    // Set neutral locale for DB dumping because otherwise %f might become 3,4
    // instead of 3.4.
    Locale.setDefault(Locale.ROOT)

    val reader = (
      if (args.size == 1) Source.fromFile(args(0))
      else Source.fromInputStream(System.in)
    ).bufferedReader

    try {
      while (true) {
        val line = reader.readLine

        // Exit if input is gone
        if (line == null) {
          System.exit(0)
        }

        val response = dispatchCommand(line)
        println(response.toJson)
      }
    }
    catch {
      case e: Exception => {
        val error = e.toString + "\n\n" + e.getStackTraceString
        System.err.println(error)
        println(Map("error" -> error).toJson)
        System.exit(-1)
      }
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
          case "create_galaxy" => spacemule.modules.pmg.Runner.createGalaxy(
              input)
          case "create_players" => spacemule.modules.pmg.Runner.createPlayers(
              input)
          case "crash" => throw new Exception("Crashing, as you requested!")
        }
      }
      case None => Map[String, String]("error" -> "unknown_action")
    }
  }
}