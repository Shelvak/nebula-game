require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::GroundFactory do
  it_behaves_like "with army points", Factory.build(:b_ground_factory)
end