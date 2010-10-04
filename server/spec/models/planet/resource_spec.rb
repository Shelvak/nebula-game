require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Planet::Resource do
  it "should include Planet::Unlandable" do
    Planet::Resource.should include(Planet::Unlandable)
  end

  it "should include Planet::Minable" do
    Planet::Resource.should include(Planet::Minable)
  end
end