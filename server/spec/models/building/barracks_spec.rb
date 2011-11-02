require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Barracks do
  it_behaves_like "with army points", Factory.build(:b_barracks)
end