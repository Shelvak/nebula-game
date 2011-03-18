describe "fow entry", :shared => true do
  describe ".for" do
    it "should return player entries" do
      model = Factory.create :"#{@short_factory_name}_player"
      @klass.for(model.player).should == [model]
    end

    it "should also return alliance entries" do
      alliance = Factory.create :alliance
      player = Factory.create :player, :alliance => alliance
      model = Factory.create :"#{@short_factory_name}_alliance",
        :alliance => alliance
      @klass.for(player).should == [model]
    end
  end

  describe ".increase" do
    it "should fire event if created" do
      should_fire_event(FowChangeEvent.new(@player, @player.alliance),
          EventBroker::FOW_CHANGE, @event_reason) do
        @klass.increase(@first_arg, @player)
      end
    end

    it "should return true if created" do
      @klass.increase(@first_arg, @player).should be_true
    end

    it "should not fire event if updated" do
      @klass.increase(@first_arg, @player)
      should_not_fire_event(FowChangeEvent.new(@player, @player.alliance),
          EventBroker::FOW_CHANGE, @event_reason) do
        @klass.increase(@first_arg, @player)
      end
    end

    it "should return false if updated" do
      @klass.increase(@first_arg, @player)
      @klass.increase(@first_arg, @player).should be_false
    end

    it "should create new record if one doesn't exist" do
      @klass.increase(@first_arg, @player)
      @klass.find(:first,
        :conditions => @conditions.merge(:player_id => @player.id)
      ).counter.should == 1
    end

    it "should work without alliance too" do
      lambda do
        @klass.increase(@first_arg, Factory.create(:player))
      end.should_not raise_error
    end

    it "should also create new record for alliance" do
      @klass.increase(@first_arg, @player)
      @klass.find(:first,
        :conditions => @conditions.merge(
          :alliance_id => @player.alliance_id
        )
      ).counter.should == 1
    end

    it "should update existing record if one exists" do
      @klass.increase(@first_arg, @player)
      @klass.increase(@first_arg, @player, 2)

      @klass.find(:first,
        :conditions => @conditions.merge(:player_id => @player.id)
      ).counter.should == 3
    end

    it "should update existing alliance records" do
      @klass.increase(@first_arg, @player)
      player2 = Factory.create(:player, :galaxy => @player.galaxy,
        :alliance => @alliance)

      @klass.increase(@first_arg, player2)
      @klass.find(:first, :conditions => @conditions.merge(
          :alliance_id => player2.alliance_id
        )
      ).counter.should == 2
    end
  end

  describe ".decrease" do
    before(:each) do
      @klass.increase(@first_arg, @player, 2)
    end

    it "should decrement counter" do
      @klass.decrease(@first_arg, @player)
      @klass.find(:first,
        :conditions => @conditions.merge(:player_id => @player.id)
      ).counter.should == 1
    end

    it "should return true if destroyed" do
      @klass.decrease(@first_arg, @player, 2).should be_true
    end

    it "should not fire event if updated" do
      should_not_fire_event(FowChangeEvent.new(@player, @player.alliance),
          EventBroker::FOW_CHANGE, @event_reason) do
        @klass.decrease(@first_arg, @player, 1)
      end
    end

    it "should return false if updated" do
      @klass.decrease(@first_arg, @player, 1).should be_false
    end

    it "should work without alliance too" do
      player = Factory.create(:player)
      @klass.increase(@first_arg, player, 2)
      lambda do
        @klass.decrease(@first_arg, player)
      end.should_not raise_error
    end

    it "should decrement alliance counter too" do
      @klass.decrease(@first_arg, @player)
      @klass.find(:first, :conditions => @conditions.merge(
          :alliance_id => @player.alliance_id
        )
      ).counter.should == 1
    end

    it "should delete useless rows (player)" do
      @klass.decrease(@first_arg, @player, 2)

      @klass.find(:all,
        :conditions => @conditions.merge(:player_id => @player.id)
      ).should == []
    end

    it "should delete useless rows (alliance)" do
      @klass.decrease(@first_arg, @player, 2)

      @klass.find(:all,
        :conditions => @conditions.merge(
          :alliance_id => @player.alliance_id
        )
      ).should == []
    end
  end
end