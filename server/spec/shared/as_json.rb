shared_examples_for "as json" do
  |model, options, required_fields, ommited_fields|
  
  (required_fields || []).each do |attr|
    if attr.is_a?(Array)
      attr, block, title = attr
      it "should include #{attr} field when #{title}" do
        block.call(model)
        model.as_json(options).should have_key(attr.to_s)
      end
    else
      it "should include #{attr} field" do
        model.as_json(options).should have_key(attr.to_s)
      end
    end
  end

  (ommited_fields || []).each do |attr|
    if attr.is_a?(Array)
      attr, block, title = attr
      it "should not include #{attr} field when #{title}" do
        block.call(model)
        model.as_json(options).should_not have_key(attr.to_s)
      end
    else
      it "should not include #{attr} field" do
        model.as_json(options).should_not have_key(attr.to_s)
      end
    end
  end

  it "should work if #as_json options is nil" do
    lambda do
      JSON.generate(model.as_json(nil))
    end.should_not raise_error
  end
end
