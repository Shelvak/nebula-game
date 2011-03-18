package spacemule.modules.combat.objects

import spacemule.modules.config.objects.Config

object Resources {
  private def resourceVolume(resource: Double, volume: Double) =
    (resource / volume).ceil
  def metalVolume(metal: Int) = resourceVolume(metal, Config.metalVolume)
  def energyVolume(energy: Int) = resourceVolume(energy, Config.energyVolume)
  def zetiumVolume(zetium: Int) = resourceVolume(zetium, Config.zetiumVolume)

  def totalVolume(metal: Int, energy: Int, zetium: Int) =
    metalVolume(metal) + energyVolume(energy) + zetiumVolume(zetium)
}
