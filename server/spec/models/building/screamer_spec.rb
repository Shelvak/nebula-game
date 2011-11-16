require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Screamer do
  it_behaves_like "with army points", Factory.build(:b_screamer)
  it_behaves_like "with repairable", Factory.build(:b_screamer)
end