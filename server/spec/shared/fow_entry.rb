shared_examples_for "fow entry" do
  describe ".for" do
    describe "player is not in alliance" do
      it "should return player entries" do
        increase[player]
        klass.for(player).sort.should == lookup.call.all.sort
      end
    end

    describe "player is in alliance" do
      it "should return player & alliance entries" do
        increase[player_w_alliance]
        klass.for(player_w_alliance).sort.should == lookup.call.all.sort
      end
    end
  end

  describe ".increase" do
    it "should fire event if created" do
      should_fire_event(
        Event::FowChange.new(player_w_alliance, alliance),
        EventBroker::FOW_CHANGE, event_reason
      ) do
        increase[player_w_alliance]
      end
    end

    it "should return true if created" do
      increase[player].should be_true
    end

    it "should not fire event if updated" do
      increase[player]
      should_not_fire_event(
        Event::FowChange.new(player_w_alliance, alliance),
        EventBroker::FOW_CHANGE, event_reason
      ) do
        increase[player]
      end
    end

    it "should return false if updated" do
      increase[player]
      increase[player].should be_false
    end

    it "should create new record if one doesn't exist" do
      increase[player]
      lookup.call(:player_id => player.id).first.counter.should == 1
    end

    it "should work without alliance too" do
      increase(player)
    end

    it "should also create new record for alliance" do
      increase[player_w_alliance]
      lookup.call(:alliance_id => alliance.id).first.counter.should == 1
    end

    it "should update existing record if one exists" do
      increase[player]
      increase[player, 2]

      lookup.call(:player_id => player.id).first.counter.should == 3
    end

    it "should update existing alliance records" do
      increase[player_w_alliance]
      player2 = Factory.create(
        :player, :galaxy => alliance.galaxy, :alliance => alliance
      )

      increase[player2]
      lookup.call(:alliance_id => alliance.id).first.counter.should == 2
      # Check if player record was created.
      lookup.call(:player_id => player2.id).first.counter.should == 1
    end
  end

  describe ".decrease" do
    describe "without alliance" do
      before(:each) do
        increase[player, 2]
      end

      it "should decrement counter" do
        decrease[player]
        lookup.call(:player_id => player.id).first.counter.should == 1
      end

      it "should return true if destroyed" do
        decrease[player, 2].should be_true
      end

      it "should not fire event if updated" do
        should_not_fire_event(
          Event::FowChange.new(player, nil),
          EventBroker::FOW_CHANGE, event_reason
        ) do
          decrease[player]
        end
      end

      it "should return false if updated" do
        decrease[player].should be_false
      end
    end

    describe "with alliance" do
      before(:each) do
        increase[player_w_alliance, 2]
      end

      it "should work" do
        decrease[player_w_alliance]
      end

      it "should decrement counter" do
        decrease[player_w_alliance]
        lookup.call(:alliance_id => alliance.id).first.counter.should == 1
      end

      it "should delete player rows" do
        decrease[player_w_alliance, 2]
        lookup.call(:player_id => player_w_alliance.id).should_not exist
      end

      it "should delete alliance rows" do
        decrease[player_w_alliance, 2]
        lookup.call(:alliance_id => alliance.id).should_not exist
      end
    end
  end
end