package spacemule.modules.config.objects

import spacemule.helpers.Converters._
import spacemule.helpers.JRuby._
import org.jruby.runtime.builtin.IRubyObject

/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 12/23/11
 * Time: 11:48 AM
 * To change this template use File | Settings | File Templates.
 */

object SsMapSet {
  def extract(data: SRArray) = {
    val (configs, weights) = data.foldLeft(
      (IndexedSeq.empty[SsConfig.Data], Seq.empty[Int])
    ) { case ((cfgs, wghts), rbMap) =>
      val map = rbMap.asMap

      val weight = map.by("weight") match {
        case Some(obj: IRubyObject) => obj.asInt
        case None => sys.error("No 'weight' for %s".format(map))
      }
      val config = map.by("map") match {
        case Some(data: IRubyObject) => SsConfig(data.asMap)
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