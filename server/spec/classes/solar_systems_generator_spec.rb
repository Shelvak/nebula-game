require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SolarSystemsGenerator do
  before(:each) do
    @galaxy = Factory.create :galaxy
    @object = SolarSystemsGenerator.new(@galaxy.id)
    @object.class.send(:public,
      :can_create_new_homeworld?,
      :find_location_for_new_homeworld,
      :find_location_for_new_system
    )
    @object.send(:init_build_variables)
  end

  describe "#can_create_new_homeworld?" do
    before(:each) do
      radius = CONFIG['galaxy.homeworld.zone_radius']
      Galaxy.stub!(:homeworld_zone).and_return([
        -radius..radius,
        -radius..radius
      ])
    end

    it "should return true if there is no other homeworld in area" do
      @object.can_create_new_homeworld?(0, 0).should be_true
    end

    it "should return false if there is other homeworld in area" do
      @object.send(:flag_homeworld_zone, 1, 0)
      @object.can_create_new_homeworld?(0, 0).should be_false
    end
  end

  describe "#find_location_for_new_homeworld" do
    it "should return START_POSITION for empty galaxy" do
      @object.find_location_for_new_homeworld.should eql(Galaxy::START_POSITION)
    end

    it "should return some position where we can put new homeworld" do
      @object.send(:flag_homeworld_zone, 1, 0)
      result = @object.find_location_for_new_homeworld
      @object.can_create_new_homeworld?(*result).should be_true
    end
  end

  describe "#find_location_for_new_system" do
    before(:each) do
      @hx = 0
      @hy = 0
      @object.send(:flag_homeworld_zone, @hx, @hy)
    end

    it "should return position in homeworld zone" do
      x_zone, y_zone = Galaxy.homeworld_zone(@hx, @hy)
      x, y = @object.find_location_for_new_system(@hx, @hy)
      x_zone.should include(x)
      y_zone.should include(y)
    end

    it "should return empty space" do
      radius = CONFIG['galaxy.homeworld.zone_radius']

      positions = []
      (@hx - radius).upto(@hx + radius) do |x|
        (@hy - radius).upto(@hy + radius) do |y|
          positions.push [x, y]
        end
      end

      # Leave one position free
      free = positions.pop

      positions.each do |x, y|
        @object.send(:create_solar_system, :expansion, x, y)
      end

      @object.find_location_for_new_system(@hx, @hy).should == free
    end
  end
end