/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.persistence.objects

import scala.collection.{Set, Map}

case class SaveResult(
  playerRows: Set[PlayerRow],
  // FOW solar system entries for existing players/alliances
  fsesForExisting: Map[SolarSystemRow, Seq[FowSsEntryRow]]
)