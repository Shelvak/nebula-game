require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Vulcan do
  it_behaves_like "with army points", Factory.build(:b_vulcan)
end