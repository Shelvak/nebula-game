require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Technology::SuperconductorTechnology do
  describe "resource increasing technology" do
    before(:each) do
      @model = Factory.create :t_superconductor_technology
    end

    it_should_behave_like "resource increasing technology"
  end
end