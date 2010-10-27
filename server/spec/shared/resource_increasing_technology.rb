describe "resource increasing technology", :shared => true do
  before(:each) do
    @time = 5.seconds.ago.drop_usec

    @p1 = Factory.create :planet, :player => @model.player
    @p1.last_resources_update = @time
    @p1.save!
    @p2 = Factory.create :planet, :player => @model.player
    @p2.last_resources_update = @time
    @p2.save!
    @p3 = Factory.create :planet
    @p3.last_resources_update = @time
    @p3.save!
  end

  it "should include itself in ResourcesEntry mod list" do
    SsObject::Planet.modifiers.should include(@model.class.to_s.demodulize)
  end

  it "should fetch all the resource entries belonging to player " +
  "on upgrade" do
    @model.send(:on_upgrade_finished)
    SsObject.connection.select_values(
      "SELECT last_resources_update FROM `#{SsObject.table_name}` p " +
      "WHERE p.player_id=#{@model.player_id}"
    ).uniq.should == [Time.now.to_s(:db)]
  end
end