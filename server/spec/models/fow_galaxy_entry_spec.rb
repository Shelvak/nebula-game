require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe FowGalaxyEntry do
  describe ".conditions" do
    it "should return false condition if entries are blank" do
      FowGalaxyEntry.conditions([]).should == "1=0"
    end

    it "should return conditions joined by OR" do
      fge1 = Factory.create(:fge, :x => 0, :x_end => 3,
        :y => 0, :y_end => 6)
      fge2 = Factory.create(:fge, :x => -3, :x_end => 3,
        :y => -2, :y_end => 6, :galaxy => fge1.galaxy)

      FowGalaxyEntry.conditions([fge1, fge2]).should == \
        "(" +
          "(location_x BETWEEN #{fge1.x} AND #{fge1.x_end} AND " +
          "location_y BETWEEN #{fge1.y} AND #{fge1.y_end}) OR " +
          "(location_x BETWEEN #{fge2.x} AND #{fge2.x_end} AND " +
          "location_y BETWEEN #{fge2.y} AND #{fge2.y_end})" +
        ") AND (location_galaxy_id=#{fge1.galaxy_id})"
    end
  end

  describe ".observer_player_ids" do
    before(:all) do
      alliance = Factory.create :alliance
      galaxy = Factory.create :galaxy
      @observer = Factory.create :player, :alliance => alliance,
        :galaxy => galaxy
      @observer_alliance = Factory.create :player, :alliance => alliance,
        :galaxy => galaxy
      @non_observer = Factory.create :player, :galaxy => galaxy

      FowGalaxyEntry.increase(Rectangle.new(0, 0, 0, 0), @observer)

      @result = FowGalaxyEntry.observer_player_ids(galaxy.id, 0, 0)
    end
    
    it "should return player id that directly observes that spot" do
      @result.should include(@observer.id)
    end

    it "should return player id that observes that spot via alliance" do
      @result.should include(@observer_alliance.id)
    end

    it "should not return player id that doesn't see that spot" do
      @result.should_not include(@non_observer.id)
    end
  end

  describe ".by_coords" do
    [
      ["top-left", [10, -10, 30, -30], [10, -10]],
      ["top-right", [-10, -10, -30, -30], [-10, -10]],
      ["bottom-left", [10, 10, 30, 30], [10, 10]],
      ["bottom-right", [-10, 10, -30, 30], [-10, 10]],
    ].each do |corner, rectangle, coords|
      it "should get by #{corner} corner" do
        model = Factory.create :fge,
          :rectangle => Rectangle.new(*rectangle)
        FowGalaxyEntry.by_coords(*coords).scoped_by_galaxy_id(
          model.galaxy_id).first.should == model
      end
    end
  end

  describe "as json" do
    it_behaves_like "as json", Factory.create(:fge), nil,
                    %w{x y x_end y_end},
                    %w{id player_id alliance_id counter}
  end

  describe "fow entry" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:solar_system) { Factory.create(:solar_system, :galaxy => galaxy) }
    let(:klass) { FowGalaxyEntry }
    let(:player) { Factory.create(:player, :galaxy => galaxy) }
    let(:player_w_alliance) do
      Factory.create(:player, :alliance => alliance, :galaxy => galaxy)
    end
    let(:alliance) do
      Factory.create(:alliance, :galaxy => galaxy)
    end
    let(:event_reason) { EventBroker::REASON_GALAXY_ENTRY }
    let(:rectangle) { Rectangle.new(0, 0, 4, 4) }

    let(:increase) do
      lambda { |*args| klass.increase(rectangle, *args) }
    end
    let(:decrease) do
      lambda { |*args| klass.decrease(rectangle, *args) }
    end
    let(:lookup) do
      lambda do |*args|
        scope = klass.where(
          :x => rectangle.x,
          :x_end => rectangle.x_end,
          :y => rectangle.y,
          :y_end => rectangle.y_end,
          :galaxy_id => galaxy.id
        )
        scope = scope.where(*args) unless args.blank?
        scope
      end
    end

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
        increase[player]
      end

      it "should update existing record if one exists" do
        increase[player]
        increase[player, 2]

        lookup.call(:player_id => player.id).first.counter.should == 3
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

        it "should delete player rows" do
          decrease[player_w_alliance, 2]
          lookup.call(:player_id => player_w_alliance.id).should_not exist
        end
      end
    end

    it "should fire event if destroyed" do
      increase[player]

      should_fire_event(
        Event::FowChange.new(player, nil), EventBroker::FOW_CHANGE, event_reason
      ) do
        decrease[player]
      end
    end

    def count_for_alliance(alliance_id)
      counters = {}
      FowGalaxyEntry.where(:alliance_id => alliance_id).all.each do |entry|
        rectangle = Rectangle.new(entry.x, entry.y, entry.x_end, entry.y_end)
        counters[rectangle] = entry.counter
      end

      counters
    end
  end
end