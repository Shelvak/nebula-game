describe "with :perspective", :shared => true do
  it "should include status if given player id" do
    @model.as_json(:perspective => @player)["status"].should == @status
  end

  it "should include status if given resolver" do
    @model.as_json(
      :perspective => StatusResolver.new(@player)
    )["status"].should == @status
  end
end