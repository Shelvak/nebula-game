require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe PlanetsGenerator do
  before(:each) do
    @galaxy_id = 1
    @id = Factory.create(:solar_system).id
    @type = :homeworld
    @object = PlanetsGenerator.new(@galaxy_id)
  end

  describe "#build" do
    it "should call Map.dimensions_for_area" do
      Map.should_receive(:dimensions_for_area).at_least(1)
      @object.build(@type, @id)
    end

    %w{homeworld regular mining resource npc}.each do |type|
      it "should have it's variation set from its planet_class" do
        value = 1234
        "Planet::#{type.camelcase}".constantize.should_receive(
          "variation").at_least(1).and_return(value)
        @object.build(@type, @id)
        @object.save(false)
        Planet.find(:first, :conditions => {
            :solar_system_id => @id, :type => type.camelcase}
        ).variation.should == value
      end
    end

    %w{mining resource}.each do |type|
      %w{metal energy zetium}.each do |resource|
        it "should set #{resource}_rate when creating #{type} planet" do
          value = 1234
          "Planet::#{type.camelcase}".constantize.should_receive(
            "#{resource}_rate").at_least(1).and_return(value)
          @object.build(@type, @id)
          @object.save(false)
          Planet.find(:first, :conditions => {
              :solar_system_id => @id, :type => type.camelcase}
          ).send("#{resource}_rate").should == value
        end
      end
    end

    %w{regular}.each do |type|
      %w{metal energy zetium}.each do |resource|
        it "should have #{resource}_rate set to nil when creating #{type} planet" do
          @object.build(@type, @id)
          @object.save(false)
          Planet.find(:first, :conditions => {
              :solar_system_id => @id, :type => type.camelcase}
          ).send("#{resource}_rate").should be_nil
        end
      end
    end
  end

  describe "#save" do
    it "should call Planet.size_from_dimensions with size" do
      Planet.should_receive(:size_from_dimensions).at_least(1
        ).and_return(CONFIG.hashrand('planet.size'))
      @object.build(@type, @id)
      @object.save(false)
    end
  end
end