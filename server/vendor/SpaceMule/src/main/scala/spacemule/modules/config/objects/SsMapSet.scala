package spacemule.modules.config.objects

import spacemule.helpers.Converters._

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/23/11
 * Time: 11:48 AM
 * To change this template use File | Settings | File Templates.
 */

object SsMapSet {
  def extract(data: Any) = {
    val (configs, weights) = data.asInstanceOf[
      Seq[Map[String, Any]]
    ].foldLeft(
      (IndexedSeq.empty[SsConfig.Data], Seq.empty[Int])
    ) { case ((cfgs, wghts), map) =>
      val weight = map.get("weight") match {
        case Some(long: Long) => long.toInt
        case None => sys.error("No 'weight' for %s".format(map))
      }
      val config = map.get("map") match {
        case Some(data: Map[String, SsConfig.CfgMap]) => SsConfig(data)
        case None => sys.error("No 'map' for %s".format(map))
      }
      
      (cfgs :+ config, wghts :+ weight)
    }

    new SsMapSet(configs, weights)
  }
}

class SsMapSet(configs: IndexedSeq[SsConfig.Data], weights: Seq[Int]) {
  def random = configs.weightedRandom(weights)
}