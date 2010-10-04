require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Planet::Mining do
  it "should include Planet::Unlandable" do
    Planet::Mining.should include(Planet::Unlandable)
  end

  it "should include Planet::Minable" do
    Planet::Mining.should include(Planet::Minable)
  end
end