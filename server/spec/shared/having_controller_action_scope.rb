shared_examples_for "having controller action scope" do
  it "should have action scope" do
    controller_name, action = @action.split(Dispatcher::Message::SPLITTER)
    controller = "#{controller_name.camelcase}Controller".constantize
    controller.const_get(:"#{action.upcase}_SCOPE")
  end
end