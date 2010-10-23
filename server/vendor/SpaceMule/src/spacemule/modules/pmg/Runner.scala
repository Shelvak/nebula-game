/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg

import spacemule.helpers.Converters._
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.Manager

object Runner {
  def run(input: Map[String, Any]): Map[String, Any] = {
    val galaxy = new Galaxy(
      input.getOrError(
        "galaxy_id", "'galaxy_id' was not defined!"
      ).asInstanceOf[Int].toInt
    )

    Manager.load(galaxy)
    
    input.getOrError(
      "player_ids",
      "'player_ids' must be defined!"
    ).asInstanceOf[List[Int]].foreach { playerId =>
      galaxy.createZoneFor(Player(playerId.toInt))
    }

    val homeworlds = Manager.save(galaxy)

    return Map[String, Any]("homeworlds" -> homeworlds)
  }
}
