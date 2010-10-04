class Building::Mothership < Building
  include Trait::Radar

  def on_upgrade_finished
    super

    CONFIG.with_scope('buildings.mothership') do |config|
      re = planet.resources_entry(true)
      re.metal += config['metal.starting'] || 0
      re.energy += config['energy.starting'] || 0
      re.zetium += config['zetium.starting'] || 0
      re.save!
    end
  end
end