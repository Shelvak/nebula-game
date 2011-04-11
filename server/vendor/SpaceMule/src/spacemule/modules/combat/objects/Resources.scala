package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

object Resources {
  type WithCost = {
    def metalCost: Int
    def energyCost: Int
    def zetiumCost: Int
  }

  private def resourceVolume(resource: Double, volume: Double): Int =
    (resource / volume).ceil.toInt
  def metalVolume(metal: Double) = resourceVolume(metal, Config.metalVolume)
  def energyVolume(energy: Double) = resourceVolume(energy, Config.energyVolume)
  def zetiumVolume(zetium: Double) = resourceVolume(zetium, Config.zetiumVolume)

  def totalVolume(metal: Double, energy: Double, zetium: Double) =
    metalVolume(metal) + energyVolume(energy) + zetiumVolume(zetium)

  def totalVolume(withCost: WithCost, percentage: Double): Int =
    totalVolume(
      withCost.metalCost * percentage,
      withCost.energyCost * percentage,
      withCost.zetiumCost * percentage
    )
}
