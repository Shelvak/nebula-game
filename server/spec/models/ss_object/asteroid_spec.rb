require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe SsObject::Asteroid do
  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:sso_asteroid)
    end

    describe "without options" do
      @ommited_fields = %w{width height metal energy zetium
        last_resources_update metal_rate metal_storage
        energy_rate energy_storage zetium_rate zetium_storage}
      it_should_behave_like "to json"
    end

    describe "with resources" do
      before(:each) do
        @options = {:resources => true}
      end

      @required_fields = %w{metal_rate metal_storage
      energy_rate energy_storage zetium_rate zetium_storage}
      @ommited_fields = %w{width height metal energy zetium
        last_resources_update}
      it_should_behave_like "to json"
    end
  end
end