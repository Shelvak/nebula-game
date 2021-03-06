require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::MobileVulcan do
  it_behaves_like "with army points", Factory.create(:b_mobile_vulcan)
  it_behaves_like "with repairable", Factory.create(:b_mobile_vulcan)
end