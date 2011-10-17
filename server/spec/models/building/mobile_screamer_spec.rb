require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::MobileScreamer do
  it_behaves_like "with army points", Factory.create(:b_mobile_screamer)
end