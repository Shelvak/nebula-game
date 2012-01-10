require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::FowChange::SsCreated do
  describe "creation" do
    let(:solar_system_id) { 10 }
    let(:x) { 15 }
    let(:y) { 20 }
    let(:kind) { SolarSystem::KIND_NORMAL }
    let(:ss_created) do
      Event::FowChange::SsCreated.new(
        solar_system_id, x, y, kind,
        [Factory.create(:fse_player), Factory.create(:fse_alliance)]
      )
    end

    it "should have #solar_system_id set" do
      ss_created.solar_system_id.should == solar_system_id
    end

    describe "metadatas" do
      %w{kind x y}.each do |attr|
        it "should have ##{attr} set" do
          ss_created.metadatas.each do |_, metadata|
            metadata.send(attr).should == send(attr)
          end
        end
      end
    end
  end
end