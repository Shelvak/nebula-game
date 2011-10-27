require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Technology::EnergyStorage do
  it_should_behave_like "resource increasing technology",
                        Factory.create!(:t_energy_storage)
end