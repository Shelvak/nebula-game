def find_planet(id)
  planet = SsObject::Planet.find(id)
  if planet
    return planet
  else
    $stderr.write "Cannot find Planet (id: #{id})!\n"
    exit
  end
end

namespace :dev do
  task :creds, [:player_id, :creds] => 'db:connection' do |task, args|
    p = Player.find(args[:player_id])
    p.creds += args[:creds].to_i
    p.save!
    puts p
  end

  namespace :res do
    desc "Maximize resources on given planet"
    task :max, [:planet_id] => 'db:connection' do |task, args|
      re = find_planet(args[:planet_id])
      re.metal = re.metal_storage
      re.energy = re.energy_storage
      re.zetium = re.zetium_storage
      re.save!

      puts "Updated to M: #{re.metal}, E: #{re.energy}, Z: #{
        re.zetium}."
    end
    
    desc "Set unholy resource rates on given planet"
    task :max_rates, [:planet_id] => 'db:connection' do |task, args|
      rate = 10000

      re = find_planet(args[:planet_id])
      re.metal_rate = re.energy_rate = re.zetium_rate = rate
      re.save!

      puts "Updated rates to #{rate}/second"
    end
  end
end
