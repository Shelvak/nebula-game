describe "resource increasing technology", :shared => true do
  before(:each) do
    @time = 5.seconds.ago.drop_usec

    @p1 = Factory.create :planet, :player => @model.player
    @re1 = @p1.resources_entry
    @re1.last_update = @time
    @re1.save!
    @p2 = Factory.create :planet, :player => @model.player
    @re2 = @p2.resources_entry
    @re2.last_update = @time
    @re2.save!
    @p3 = Factory.create :planet
    @re3 = @p3.resources_entry
    @re3.last_update = @time
    @re3.save!
  end

  it "should include itself in ResourcesEntry mod list" do
    ResourcesEntry.modifiers.should include(@model.class.to_s.demodulize)
  end

  it "should fetch all the resource entries belonging to player " +
  "on upgrade" do
    @model.send(:on_upgrade_finished)
    Planet.connection.select_values(
      "SELECT last_update FROM `#{Planet.table_name}` p " +
      "LEFT JOIN `#{ResourcesEntry.table_name}` re ON re.planet_id=p.id " +
      "WHERE p.player_id=#{@model.player_id}"
    ).uniq.should == [Time.now.to_s(:db)]
  end
end