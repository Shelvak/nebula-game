require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe TechTracker do
  it "should register technology as having mod" do
    TechTracker.register('armor', Technology::TestTechnology)
    TechTracker.get('armor').should include(Technology::TestTechnology)
  end

  describe "#query" do
    it "should return correct technologies" do
      player = Factory.create(:player)
      t1 = Factory.create(:technology, :player => player)
      t2 = Factory.create(:technology_t2, :player => player)
      Factory.create(:technology_t3, :player => player)

      TechTracker.register('armor', t1.class)
      TechTracker.register('damage', t2.class)

      TechTracker.query('armor', 'damage').where(:player_id => player.id).
        should == [t1, t2]
    end
  end
end