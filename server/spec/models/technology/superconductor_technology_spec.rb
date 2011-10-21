require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Technology::SuperconductorTechnology do
  it_behaves_like "resource increasing technology",
                  Factory.create(:t_superconductor_technology)
end