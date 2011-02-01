# Various resource related helpers.
class Resources
  # How much volume this metal takes.
  def self.metal_volume(metal); resource_volume(metal, "metal"); end
  # How much volume this energy takes.
  def self.energy_volume(energy); resource_volume(energy, "energy"); end
  # How much volume this zetium takes.
  def self.zetium_volume(zetium); resource_volume(zetium, "zetium"); end

  # How much volume this resource takes.
  def self.resource_volume(value, resource)
    (value / CONFIG["units.transportation.volume.#{resource}"]).ceil
  end

  # How much volume does this metal, energy and zetium takes.
  def self.total_volume(metal, energy, zetium)
    metal_volume(metal) + energy_volume(energy) + zetium_volume(zetium)
  end

  # Calculates difference of volume between old and new resource values.
  def self.total_volume_diff(old_metal, new_metal, old_energy,
      new_energy, old_zetium, new_zetium)
    old_volume = total_volume(old_metal, old_energy, old_zetium)
    new_volume = total_volume(new_metal, new_energy, new_zetium)

    new_volume - old_volume
  end
end
