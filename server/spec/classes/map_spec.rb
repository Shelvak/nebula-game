require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Map do
  describe ".dimensions_for_area" do
    it "should raise ArgumentError if given area is bigger than max area" do
      with_config_values(
        'planet.regular.area.from' => CONFIG['planet.area.max'] + 1,
        'planet.regular.area.to' => CONFIG['planet.area.max'] + 1
      ) do
        lambda do
          Map.dimensions_for_area('regular')
        end.should raise_error(ArgumentError)
      end
    end

    it "should return proportional width/height" do
      with_config_values(
        'planet.area.max' => 100,
        'planet.area.proportion.from' => 40,
        'planet.area.proportion.to' => 40,
        'planet.regular.area.from' => 50,
        'planet.regular.area.to' => 50
      ) do
        Map.dimensions_for_area('regular').should == [36, 14]
      end
    end
  end
end