require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::ZetiumExtractor do
  it "should manage resources" do
    Building::ZetiumExtractor.should manage_resources
  end

  it "should include ZetiumExtractor" do
    Building::ZetiumExtractor.should include(Trait::ZetiumExtractor)
  end

  it "should need ZetiumExtractor technology" do
    Building::ZetiumExtractor.should need_technology(
      Technology::ZetiumExtraction)
  end
end