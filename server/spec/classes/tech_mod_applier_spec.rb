require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TechModApplier do
  describe ".apply" do
    it "should return Hash" do
      with_config_values({
        'technologies.test_technology.mod.armor' => '10 * level',
        'technologies.test_technology.applies_to' => ['unit/trooper'],
        'technologies.test_t2.mod.damage' => '10 * level',
        'technologies.test_t2.applies_to' => ['unit/trooper'],
        'technologies.test_t3.mod.armor' => '20 * level',
        'technologies.test_t3.applies_to' => 
          ['unit/trooper', 'unit/shocker'],
      }) do
        player = Factory.create(:player)
        technologies = [
          Factory.create(:technology, :player => player, :level => 1),
          Factory.create(:technology_t2, :player => player, :level => 1),
          Factory.create(:technology_t3, :player => player, :level => 2),
        ]

        TechModApplier.apply(technologies, 'armor').should equal_to_hash({
          "Unit::Trooper" => 0.5,
          "Unit::Shocker" => 0.4
        })
      end
    end
  end
end