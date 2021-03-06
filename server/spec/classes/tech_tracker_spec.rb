require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TechTracker do
  it "should register all mod technologies upon instantiating" do
    TechTracker::MODS.each do |name|
      TechTracker.get(name).should_not be_blank
    end
  end

  it "should register technology as having mod" do
    TechTracker.register(TechTracker::ARMOR, Technology::TestTechnology)
    TechTracker.get(TechTracker::ARMOR).
      should include(Technology::TestTechnology)
  end

  describe "#query" do
    it "should return correct technologies" do
      player = Factory.create(:player)
      t1 = Factory.create(:technology, :player => player)
      t2 = Factory.create(:technology_t2, :player => player)
      Factory.create(:technology_t3, :player => player)

      TechTracker.register(TechTracker::ARMOR, t1.class)
      TechTracker.register(TechTracker::DAMAGE, t2.class)

      TechTracker.query(TechTracker::ARMOR, TechTracker::DAMAGE).
        where(:player_id => player.id).should == [t1, t2]
    end
  end
end