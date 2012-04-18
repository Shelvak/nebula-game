shared_examples_for "only push" do
  it "should fail when invoked" do
    lambda do
      message = create_message(@action, @params, false)
      check_options!(message)
    end.should raise_error(GenericController::ParamOpts::BadParams)
  end
end