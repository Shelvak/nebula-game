require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Tile do
  it "should not allow creating two tiles in same place" do
    model = Factory.create :tile
    lambda do
      Factory.create(:tile, :planet => model.planet)
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end
  
  it "should be object" do
    Tile.should include(Parts::Object)
  end
  
  describe "notifier" do
    it_behaves_like "notifier",
      :build => lambda { Factory.build(:tile, :kind => Tile::SAND) },
      :change => lambda { |tile| tile.kind = Tile::TITAN },
      :notify_on_create => false, :notify_on_update => false
  end

  describe "#as_json" do
    it_behaves_like "as json", Factory.create(:tile), nil,
                    Tile.columns.map(&:name), []
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
      @planet = Factory.create :planet
      Factory.create(:tile, :planet => @planet)
    end

    it_behaves_like "fast finding"
  end
end