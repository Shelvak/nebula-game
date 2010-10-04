require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Planet::UnlandableMock < Planet
  include Planet::Unlandable
end

Factory.define :p_unlandable, :parent => :planet,
:class => Planet::UnlandableMock do |m|; end

describe Planet::Unlandable do
  [:width, :height].each do |attr|
    it "should always have nil #{attr}" do
      model = Factory.create :p_unlandable
      model.send(attr).should be_nil
    end
  end

  it "should not have a map" do
    model = Factory.create :p_unlandable
    model.tiles.should be_empty
  end
end