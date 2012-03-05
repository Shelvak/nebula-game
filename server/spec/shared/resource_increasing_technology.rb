shared_examples_for "resource increasing technology" do |model|
  before(:each) do
    @time = 5.seconds.ago.drop_usec

    @p1 = Factory.create :planet, :player => model.player
    @p1.last_resources_update = @time
    @p1.save!
    @p2 = Factory.create :planet, :player => model.player
    @p2.last_resources_update = @time
    @p2.save!
    @p3 = Factory.create :planet
    @p3.last_resources_update = @time
    @p3.save!
  end

  describe ".resource_modifiers" do
    %w{metal energy zetium}.each do |resource|
      [
        ["", "generate"],
        ["_storage", "store"]
      ].each do |type, config_name|
        it "should return #{resource}#{type}" do
          with_config_values(
            "technologies.#{model.class.to_s.demodulize.underscore
              }.mod.#{resource}.#{config_name}" => "3.56 * level"
          ) do
            model.class.resource_modifiers(2)[
              :"#{resource}#{type}"
            ].should == 3.56 * 2
          end
        end
      end
    end
  end

  it "should fetch all the resource entries belonging to player " +
  "on upgrade" do
    opts_upgrading.apply(model)
    model.send(:on_upgrade_finished)
    time = SsObject.connection.select_value(
      "SELECT last_resources_update FROM `#{SsObject.table_name}` p " +
      "WHERE p.player_id=#{model.player_id} LIMIT 1"
    )
    # JRuby compatibility
    time = Time.parse(time) unless time.is_a?(Time)
    time.should be_within(SPEC_TIME_PRECISION).of(Time.now)
  end
end