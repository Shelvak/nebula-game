require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Technology::FieryMelters do
  describe "resource increasing technology" do
    before(:each) do
      @model = Factory.create :t_fiery_melters
    end

    it_should_behave_like "resource increasing technology"
  end
end