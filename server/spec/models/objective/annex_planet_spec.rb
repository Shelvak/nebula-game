require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Objective::AnnexPlanet do
  describe ".progress" do
    [
      ["npc", nil],
      ["non-npc", Factory.create(:player)]
    ].each do |title, owner|
      describe title do        
        it "should update objective progress for #{title} planet" do
          planet = Factory.create(:planet, :player => owner)
          objective = Factory.create :o_annex_planet, :key => "Planet",
            :npc => owner.nil?, :count => 2
          
          player = Factory.create(:player)
          objective_progress = Factory.create :objective_progress,
            :objective => objective, :player => player

          # Change planet owner
          planet.player = player

          lambda do
            objective.class.progress([planet])
            objective_progress.reload
          end.should change(objective_progress, :completed).by(1)
        end
      end
    end
  end
end