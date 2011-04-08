package spacemule.modules.combat.objects

import spacemule.helpers.Converters._
import spacemule.modules.config.objects.Config

object Wreckage {
  def metalWreckage(item: {def metalCost: Int}) =
    item.metalCost * Config.wreckageRange.random.toDouble / 100
  def energyWreckage(item: {def energyCost: Int}) =
    item.energyCost * Config.wreckageRange.random.toDouble / 100
  def zetiumWreckage(item: {def zetiumCost: Int}) =
    item.zetiumCost * Config.wreckageRange.random.toDouble / 100
}