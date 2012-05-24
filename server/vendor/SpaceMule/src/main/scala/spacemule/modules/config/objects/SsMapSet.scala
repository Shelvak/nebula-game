package spacemule.modules.config.objects

import spacemule.helpers.Converters._
import spacemule.helpers.JRuby._
import core.AnyConversions._
import scala.{collection => sc}

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/23/11
 * Time: 11:48 AM
 * To change this template use File | Settings | File Templates.
 */

object SsMapSet {
  def extract(data: Seq[Any]) = {
    val (configs, weights) = data.foldLeft(
      (IndexedSeq.empty[SsConfig.Data], Seq.empty[Int])
    ) { case ((cfgs, wghts), rbMap) =>
      val map = rbMap.asInstanceOf[sc.Map[String, Any]]

      val weight = map.get("weight") match {
        case None => sys.error("No 'weight' for %s".format(map))
        case Some(weight) => try { weight.asInt }
        catch { case e: Exception =>
          throw core.Exceptions.extend("Error while getting 'weight'", e)
        }
      }
      val config = (map.get("map"): @unchecked) match {
        case None => sys.error("No 'map' for %s".format(map))
        case Some(data) if (data.isInstanceOf[sc.Map[_, _]]) =>
          SsConfig(data.asInstanceOf[sc.Map[String, AnyRef]])
      }

      (cfgs :+ config, wghts :+ weight)
    }

    new SsMapSet(configs, weights)
  }
}

class SsMapSet(configs: IndexedSeq[SsConfig.Data], weights: Seq[Int]) {
  def random = configs.weightedRandom(weights)
}