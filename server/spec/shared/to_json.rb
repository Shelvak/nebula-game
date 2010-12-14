describe "to json", :shared => true do
  (@required_fields || []).each do |attr|
    it "should include #{attr} field" do
      @model.as_json(@options).should include(attr.to_sym)
    end
  end

  (@ommited_fields || []).each do |attr|
    it "should not include #{attr} field" do
      @model.as_json(@options).should_not include(attr.to_sym)
    end
  end

  it "should work if #as_json options is nil" do
    lambda do
      @model.as_json(nil).to_json
    end.should_not raise_error
  end
end
