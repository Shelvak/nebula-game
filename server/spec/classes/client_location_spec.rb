require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ClientLocation do
  describe "creation" do
    describe "when type is galaxy" do
      it "should not fail" do
        ClientLocation.new(10, Location::GALAXY, -5, 12)
      end
    end

    describe "when type is solar system" do
      let(:solar_system) { Factory.create(:solar_system) }
      let(:id) { solar_system.id }
      let(:type) { Location::SOLAR_SYSTEM }
      let(:x) { 0 }
      let(:y) { 0 }
      let(:client_location) { ClientLocation.new(id, type, x, y) }

      it "should fail if solar system does not exist" do
        solar_system.destroy!
        lambda do
          client_location()
        end.should raise_error(ArgumentError)
      end

      it "should set #kind" do
        client_location.kind.should == solar_system.kind
      end
    end

    describe "when type is ss object" do
      let(:ss_object) { Factory.create(:ss_object) }
      let(:id) { ss_object.id }
      let(:type) { Location::SS_OBJECT }
      let(:x) { nil }
      let(:y) { nil }
      let(:client_location) { ClientLocation.new(id, type, x, y) }

      it "should fail if ss object does not exist" do
        ss_object.destroy
        lambda do
          client_location()
        end.should raise_error(ArgumentError)
      end

      {
        :position => :x, :angle => :y, :name => :name, :terrain => :terrain,
        :solar_system_id => :solar_system_id
      }.each do |source_attr, dest_attr|
        it "should set ##{dest_attr} from SsObject##{source_attr}" do
          client_location.send(dest_attr).should == ss_object.send(source_attr)
        end
      end

      it "should set #player" do
        planet = Factory.create(:planet_with_player)
        ClientLocation.new(planet.id, type, x, y).player.
          should == Player.minimal(planet.player_id)
      end
    end
  end
end