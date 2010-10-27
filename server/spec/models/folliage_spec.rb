require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Folliage do
  describe ".fast_find_all_for_planet" do
    before(:all) do
      @klass = Folliage
      @planet = Factory.create(:planet)
      Factory.create(:folliage, :planet => @planet)
    end

    it_should_behave_like "fast finding"
  end

  describe "#to_json" do
    before(:all) do
      @model = Factory.create :tile
    end

    @ommited_fields = %w{planet_id}
    it_should_behave_like "to json"
  end
end