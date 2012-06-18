require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper.rb')
)

describe Event::FowChange::SsDestroyed do
  describe ".new" do
    let(:ss_id) { 100 }
    let(:player_ids) { [10, 20] }
    let(:event) { Event::FowChange::SsDestroyed.new(ss_id, player_ids) }

    it "should set #player_ids" do
      event.player_ids.should == player_ids
    end

    it "should set #metadata" do
      event.metadata.should == SolarSystemMetadata.destroyed(ss_id)
    end
  end

  describe ".all_except" do
    let(:solar_system_id) { 4432 }
    let(:player_id) { 1827 }
    let(:observer_ids) { [1, 2, 5, 67, player_id, 1000] }
    let(:player_ids) { observer_ids - [player_id] }

    it "should return new event with all ss observers except given id" do
      SolarSystem.should_receive(:observer_player_ids).with(solar_system_id).
        and_return(observer_ids)

      Event::FowChange::SsDestroyed.all_except(solar_system_id, player_id).
        should == Event::FowChange::SsDestroyed.new(solar_system_id, player_ids)
    end
  end
end