require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "resolving you/enemy", :shared => true do
  it "should resolve YOU" do
    @resolver.status(@player.id).should == StatusResolver::YOU
  end

  it "should resolve ENEMY" do
    @resolver.status(@enemy.id).should == StatusResolver::ENEMY
  end
end

describe StatusResolver do
  describe "#status" do
    describe "player not in alliance" do
      before(:all) do
        @player = Factory.create :player
        @enemy = Factory.create :player
        @resolver = StatusResolver.new(@player)
      end

      it_should_behave_like "resolving you/enemy"
    end

    describe "player in alliance" do
      before(:all) do
        @alliance = Factory.create :alliance
        @player = Factory.create :player, :alliance => @alliance
        @ally = Factory.create :player, :alliance => @alliance
        @nap = Factory.create :nap, :initiator => @alliance
        @nap_player = Factory.create :player, :alliance => @nap.acceptor
        @enemy = Factory.create :player
        @resolver = StatusResolver.new(@player)
      end

      it_should_behave_like "resolving you/enemy"

      it "should resolve ALLY" do
        @resolver.status(@ally.id).should == StatusResolver::ALLY
      end

      it "should resolve NAP" do
        @resolver.status(@nap_player.id).should == StatusResolver::NAP
      end
    end
  end

  describe "#resolve_objects" do
    before(:all) do
      @player = Factory.create :player
      @enemy = Factory.create :player
      @resolver = StatusResolver.new(@player)
      @mine = Factory.create :unit, :player => @player
      @enemys = Factory.create :unit, :player => @enemy
    end

    it "should return mapped array" do
      @resolver.resolve_objects([@mine, @enemys]).should == [
        {
          :object => @mine,
          :status => StatusResolver::YOU
        },
        {
          :object => @enemys,
          :status => StatusResolver::ENEMY
        }
      ]
    end
  end

  describe "#filter" do
    before(:each) do
      @player = Factory.create(:player)
      @status_resolver = StatusResolver.new(@player)
    end

    it "should reject those which do not comply to status" do
      @status_resolver.filter([nil, @player], StatusResolver::YOU, :id
        ).should == [@player]
    end

    it "should support arrays" do
      input = [nil, @player]
      @status_resolver.filter(input,
        [StatusResolver::NPC, StatusResolver::YOU], :id
        ).should == input
    end
  end
end