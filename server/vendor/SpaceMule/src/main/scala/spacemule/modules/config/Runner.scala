/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.config

import spacemule.helpers.Converters._
import spacemule.persistence.DB
import objects.Config

object Runner {
  def run(dbConfig: Map[String, String], config: ScalaConfig) {
    processDb(dbConfig)
    Config.data = config
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
      case _ => sys.error("undefined key '%s' in database config!".format(key))
    }
  }
}
