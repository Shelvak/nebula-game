package spacemule.modules.pmg.persistence

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: Oct 17, 2010
 * Time: 3:41:02 PM
 * To change this template use File | Settings | File Templates.
 */

import spacemule.persistence.DB
import spacemule.persistence

object TableIds {
  val solarSystem = new persistence.TableIds(0)
  val ssObject = new persistence.TableIds(0)
  val building = new persistence.TableIds(0)
  val unit = new persistence.TableIds(0)
  val player = new persistence.TableIds(0)
  val fowSsEntries = new persistence.TableIds(0)

  def initialize() = {
    solarSystem.current = currentFor(Manager.solarSystemsTable)
    ssObject.current = currentFor(Manager.ssObjectsTable)
    building.current = currentFor(Manager.buildingsTable)
    unit.current = currentFor(Manager.unitsTable)
    player.current = currentFor(Manager.playersTable)
    fowSsEntries.current = currentFor(Manager.fowSsEntriesTable)
  }

  private def currentFor(table: String): Int = {
    return DB.getOne[Int]("SELECT MAX(id) FROM `%s`".format(table)) match {
      case Some(id: Int) => id
      case None => 0
    }
  }
}