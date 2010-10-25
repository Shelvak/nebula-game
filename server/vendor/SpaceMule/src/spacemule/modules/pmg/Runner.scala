/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg

import spacemule.helpers.Converters._
import spacemule.helpers.BenchmarkableMock
import spacemule.modules.pmg.objects.Galaxy
import spacemule.modules.pmg.objects.Player
import spacemule.modules.pmg.persistence.Manager

object Runner extends BenchmarkableMock {
  def run(input: Map[String, Any]): Map[String, Any] = {
    val galaxy = new Galaxy(
      input.getOrError(
        "galaxy_id", "'galaxy_id' was not defined!"
      ).asInstanceOf[Int].toInt
    )

    benchmark("load galaxy") { () => Manager.load(galaxy) }
    
    input.getOrError(
      "players",
      "'players' must be defined!"
    ).asInstanceOf[Map[String, String]].foreach { case(name, authToken) =>
      val player = Player(name, authToken)
      benchmark("create player") { () => galaxy.createZoneFor(player) }
    }

    val result = benchmark("save galaxy") { () => Manager.save(galaxy) }
    printBenchmarkResults()

    return Map[String, Any](
      "updated_player_ids" -> result.updatedPlayerIds,
      "updated_alliance_ids" -> result.updatedAllianceIds
    )
  }
}
