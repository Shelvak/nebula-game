describe "only push", :shared => true do
  it "should fail when invoked" do
    lambda do
      invoke @action, @params
    end.should raise_error(GenericController::PushRequired)
  end
end