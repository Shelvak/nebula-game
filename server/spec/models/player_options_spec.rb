require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe PlayerOptions do
  describe "#as_json" do
    it "should delegate to data#as_json" do
      opts = Factory.build(:player_options)
      opts.data.should_receive(:as_json).with(:opts)
      opts.as_json(:opts)
    end
  end

  describe ".find" do
    it "should raise error if such player does not exist" do
      lambda do
        PlayerOptions.find(-1)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return new record with default values if not found" do
      player = Factory.create(:player)
      po = PlayerOptions.find(player.id)
      {:player_id => po.player_id, :options => po.options}.should equal_to_hash(
        :player_id => player.id, :options => PlayerOptions::Data.new
      )
    end

    it "should return existing record if it exists" do
      player = Factory.create(:player)
      po = PlayerOptions.find(player.id)
      po.options.warn_before_unload = ! po.options.warn_before_unload?
      new_options = po.options
      po.save!

      po = PlayerOptions.find(player.id)
      po.options.should == new_options
    end
  end
end