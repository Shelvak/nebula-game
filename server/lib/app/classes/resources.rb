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
  rescue Exception => e
    LOGGER.error("Error in Resources.resource_volume(#{value.inspect
      }, #{resource.inspect})!")
    raise e
  end

  # How much metal we get from this volume.
  def self.volume_to_metal(volume); resource_from_volume(volume, "metal"); end
  # How much energy we get from this volume.
  def self.volume_to_energy(volume); resource_from_volume(volume, "energy"); end
  # How much zetium we get from this volume.
  def self.volume_to_zetium(volume); resource_from_volume(volume, "zetium"); end

  # How much volume this resource takes.
  def self.resource_from_volume(volume, resource)
    volume * CONFIG["units.transportation.volume.#{resource}"]
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
