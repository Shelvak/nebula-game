namespace :dev do
  namespace :res do
    desc "Maximize resources on given planet"
    task :max, [:planet_id] => 'db:connection' do |task, args|
      re = ResourcesEntry.find_by_planet_id(args[:planet_id])
      if re
        re.metal = re.metal_storage
        re.energy = re.energy_storage
        re.zetium = re.zetium_storage
        re.save!

        puts "Updated to M: #{re.metal}, E: #{re.energy}, Z: #{
          re.zetium}."
      else
        puts "Cannot find ResourcesEntry with planet id #{
          args[:planet_id]}!"
      end
    end
  end
end