require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TechModApplier do
  describe ".apply" do
    it "should return Hash" do
      with_config_values({
        # Applies only to trooper.
        'technologies.test_technology.mod.armor' => '10.5 * level',
        'technologies.test_technology.applies_to' => ['unit/trooper'],
        # Damage mod, does not apply.
        'technologies.test_t2.mod.damage' => '10.5 * level',
        'technologies.test_t2.applies_to' => ['unit/trooper'],
        # Applies to trooper/shocker.
        'technologies.test_t3.mod.armor' => '20.3 * level',
        'technologies.test_t3.applies_to' => 
          ['unit/trooper', 'unit/shocker'],
      }) do
        player = Factory.create(:player)
        technologies = [
          Factory.create(:technology, :player => player, :level => 1),
          Factory.create(:technology_t2, :player => player, :level => 1),
          Factory.create(:technology_t3, :player => player, :level => 2),
        ]

        TechModApplier.apply(technologies, TechTracker::ARMOR).
          should equal_to_hash({
            "Unit::Trooper" => 0.105 + 0.203 * 2,
            "Unit::Shocker" => 0.203 * 2
          })
      end
    end
  end
end