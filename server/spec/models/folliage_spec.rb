require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Folliage do
  describe ".fast_find_all_for_planet" do
    before(:all) do
      @klass = Folliage
      @planet = Factory.create(:planet)
      Factory.create(:folliage, :planet => @planet)
    end

    it_behaves_like "fast finding"
  end

  describe "#as_json" do
    it_behaves_like "as json", Factory.create(:folliage), nil,
                    %w{}, %w{planet_id}
  end
end