require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Technology::PowderedZetium do
  describe "resource increasing technology" do
    before(:each) do
      @model = Factory.create! :t_powdered_zetium
    end

    it_behaves_like "resource increasing technology"
  end
end