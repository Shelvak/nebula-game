describe "with param options", :shared => true do
  (@required_params || []).each do |param|
    it "should require #{param} parameter" do
      lambda do
        @params.delete param
        send(@method || 'invoke', @action, @params)
      end.should raise_error(ControllerArgumentError)
    end
  end
end