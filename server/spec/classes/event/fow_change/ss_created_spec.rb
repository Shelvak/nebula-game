require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::FowChange::SsCreated do
  describe "creation" do
    let(:solar_system) { Factory.create(:solar_system) }
    let(:x) { 15 }
    let(:y) { 20 }
    let(:kind) { SolarSystem::KIND_NORMAL }
    let(:ss_created) do
      Event::FowChange::SsCreated.new(
        solar_system.id, x, y, kind, nil,
        [
          Factory.create(:fse_player, :solar_system => solar_system),
          Factory.create(:fse_alliance, :solar_system => solar_system)
        ]
      )
    end

    it "should have #solar_system_id set" do
      ss_created.solar_system_id.should == solar_system.id
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