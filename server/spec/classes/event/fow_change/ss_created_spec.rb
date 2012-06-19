require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::FowChange::SsCreated do
  describe "creation" do
    let(:solar_system) { Factory.create(:solar_system) }
    let(:x) { 15 }
    let(:y) { 20 }
    let(:kind) { SolarSystem::KIND_NORMAL }
    let(:players) { [Factory.create(:player), Factory.create(:player)] }
    let(:metadatas) { SolarSystem::Metadatas.new(solar_system.id) }
    let(:ss_created) do
      Event::FowChange::SsCreated.new(
        solar_system.id, x, y, kind, nil, players, metadatas
      )
    end

    it "should have #solar_system_id set" do
      ss_created.solar_system_id.should == solar_system.id
    end

    it "should have #player_ids set" do
      ss_created.player_ids.should == players.map(&:id)
    end

    describe "metadatas" do
      %w{kind x y}.each do |attr|
        it "should have ##{attr} set" do
          ss_created.metadatas.each do |player_id, metadata|
            metadata.send(attr).should == send(attr)
          end
        end
      end
    end
  end
end