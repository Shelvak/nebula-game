require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Technology::PowderedZetium do
  describe "resource increasing technology" do
    before(:each) do
      @model = Factory.build :t_powdered_zetium
      @model.stub!(:validate_technologies)
      @model.save!
    end

    it_should_behave_like "resource increasing technology"
  end
end