require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::ZetiumStorage do
  it "should manage resources" do
    Building::ZetiumStorage.should manage_resources
  end

  it "should need ZetiumExtractor technology" do
    Building::ZetiumStorage.should need_technology(
      Technology::ZetiumExtraction)
  end
end