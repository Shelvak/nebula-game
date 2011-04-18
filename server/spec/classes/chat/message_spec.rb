require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Message do
  describe ".store!" do
    it "should save item to db" do
      source = Factory.create(:player)
      target = Factory.create(:player)
      message = "FOOO!"
      Chat::Message.store!(source.id, target.id, message)
      ActiveRecord::Base.connection.select_one(
        "SELECT * FROM `#{Chat::Message.table_name}` WHERE source_id=#{
        source.id}"
      ).should equal_to_hash(
        'source_id' => source.id,
        'target_id' => target.id,
        'message' => message,
        'created_at' => Time.now
      )
    end
  end

  describe ".retrieve" do
    it "should retrieve rows sorted by created_at" do
      source = Factory.create(:player)
      target = Factory.create(:player)
      Chat::Message.new(:source_id => source.id, :target_id => target.id,
        :message => "BAR!", :created_at => 5.minutes.ago).save!
      Chat::Message.new(:source_id => source.id, :target_id => target.id,
        :message => "FOO!", :created_at => 10.minutes.ago).save!
      Chat::Message.retrieve(target.id).should == [
        {'source_id' => source.id, 'message' => "FOO!",
          'created_at' => 10.minutes.ago},
        {'source_id' => source.id, 'message' => "BAR!",
          'created_at' => 5.minutes.ago}
      ]
    end
  end

  describe ".retrieve!" do
    before(:each) do
      @source = Factory.create(:player)
      @target = Factory.create(:player)
      @message = "FOOO!"
      Chat::Message.store!(@source.id, @target.id, @message)
    end

    it "should retrieve messages" do
      messages = Chat::Message.retrieve(@target.id)
      Chat::Message.retrieve!(@target.id).should == messages
    end

    it "should delete them from db" do
      Chat::Message.retrieve!(@target.id)
      Chat::Message.retrieve!(@target.id).should be_blank
    end

    it "should not delete other target messages" do
      target2 = Factory.create(:player)
      Chat::Message.store!(@source.id, target2.id, @message)
      Chat::Message.retrieve!(@target.id)
      Chat::Message.retrieve(target2.id).should_not be_blank
    end
  end
end