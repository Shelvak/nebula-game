require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Tile do
  it "should not allow creating two tiles in same place" do
    model = Factory.create :tile
    Factory.build(:tile, :planet => model.planet).should_not be_valid
  end

  describe "#to_json" do
    before(:all) do
      @model = Factory.create(:tile)
    end

    @ommited_fields = %w{planet_id}
    it_should_behave_like "to json"
  end

  describe ".for_building" do
    before(:all) do
      @planet = Factory.create :planet
      @tile1 = Factory.create :t_sand, :planet => @planet, :x => 0, :y => 0
      @tile2 = Factory.create :t_titan, :planet => @planet, :x => 1, :y => 0
      @building = Factory.create(:building, :planet => @planet)
    end

    it "should return tiles for building" do
      Tile.for_building(@building).all.sort.should == [@tile1, @tile2].sort
    end
  end

  describe ".fast_find_all_for_planet" do
    before(:all) do
      @klass = Tile
    end

    it_should_behave_like "fast finding"
  end
end