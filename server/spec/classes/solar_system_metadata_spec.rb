require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystemMetadata do
  it "should be object" do
    SolarSystemMetadata.should include(Parts::Object)
  end
end