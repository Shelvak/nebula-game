require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Zone do
  describe ".different?" do
    it "should return true if types differ" do
      Zone.different?(
        GalaxyPoint.new(0, 0, 0),
        SolarSystemPoint.new(0, 1, 0)
      ).should be_true
    end

    it "should return true if ids differ" do
      Zone.different?(
        GalaxyPoint.new(0, 0, 0),
        GalaxyPoint.new(1, 0, 0)
      ).should be_true
    end

    it "should return false otherwise" do
      Zone.different?(
        GalaxyPoint.new(0, 0, 0),
        GalaxyPoint.new(0, 1, 1)
      ).should be_false
    end
  end
end