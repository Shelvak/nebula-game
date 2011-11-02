require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::SpaceFactory do
  it_behaves_like "with army points", Factory.build(:b_space_factory)
end