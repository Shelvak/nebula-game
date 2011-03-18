describe "with unit bonus", :shared => true do
  it "should return property on #unit_bonus" do
    @model.unit_bonus.should == @model.property('unit_bonus')
  end

  it "should give units on cooldown" do
    Unit.should_receive(:give_units).with(@model.unit_bonus, @planet,
      @player)
    @model.cooldown_expired!
  end

  it "should not give units if planet has no player" do
    @model.planet = Factory.create(:planet)
    Unit.should_not_receive(:give_units)
    @model.cooldown_expired!
  end
end