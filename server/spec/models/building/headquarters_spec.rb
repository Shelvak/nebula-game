require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::Headquarters do
  it "should be a constructor" do
    Building::Headquarters.should be_constructor
  end

  it "should manage resources" do
    Building::Headquarters.should manage_resources
  end
end