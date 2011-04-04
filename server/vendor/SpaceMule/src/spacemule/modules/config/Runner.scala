/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config

import spacemule.helpers.Converters._
import spacemule.persistence.DB
import objects.Config

object Runner {
  def run(input: Map[String, Any]): Map[String, Any] = {
    val db = input.getOrError(
      "db", "key 'db' in action 'config' not found!"
    ).asInstanceOf[Map[String, String]]
    processDb(db)

    Config.sets = input.getOrError(
      "sets", "key 'sets' in action 'config' not found!"
    ).asInstanceOf[Map[String, Map[String, Any]]]

    return Map[String, Any]("success" -> true)
  }

  private def processDb(config: Map[String, String]) = {
    DB.connect(
      dbGet(config, "host"),
      dbGet(config, "username"),
      dbGet(config, "password"),
      dbGet(config, "database")
    )
  }

  private def dbGet(config: Map[String, String], key: String): String = {
    return config.get(key) match {
      case Some(null) => ""
      case Some(string) => string
      case _ => error("undefined key '%s' in database config!".format(key))
    }
  }
}
