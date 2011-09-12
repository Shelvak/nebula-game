shared_examples_for "shieldable" do
  describe "#as_json" do
    fields = %w{shield_ends_at shield_owner_id}

    describe "when has shield" do
      before(:each) do
        @model.stub!(:has_shield?).and_return(true)
      end

      @required_fields = fields

      it_behaves_like "to json"
    end

    describe "when does not have shield" do
      before(:each) do
        @model.stub!(:has_shield?).and_return(false)
      end

      @ommited_fields = fields

      it_behaves_like "to json"
    end
  end
end