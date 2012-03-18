require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe FowGalaxyEntry do
  describe ".conditions" do
    it "should return false condition if entries are blank" do
      FowGalaxyEntry.conditions([]).should == "1=0"
    end

    it "should return conditions joined by OR" do
      fge1 = Factory.create(:fge_player, :x => 0, :x_end => 3,
        :y => 0, :y_end => 6)
      fge2 = Factory.create(:fge_player, :x => -3, :x_end => 3,
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
        model = Factory.create :fge_player,
          :rectangle => Rectangle.new(*rectangle)
        FowGalaxyEntry.by_coords(*coords).scoped_by_galaxy_id(
          model.galaxy_id).first.should == model
      end
    end
  end

  describe "as json" do
    it_behaves_like "as json", Factory.create(:fge_player), nil,
                    %w{x y x_end y_end},
                    %w{id player_id alliance_id counter}
  end

  describe "fow entry" do
    let(:solar_system) { Factory.create(:solar_system) }
    let(:klass) { FowGalaxyEntry }
    let(:player) { Factory.create(:player) }
    let(:player_w_alliance) { Factory.create(:player, :alliance => alliance) }
    let(:alliance) { Factory.create(:alliance) }
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
          :y_end => rectangle.y_end
        )
        scope = scope.where(*args) unless args.blank?
        scope
      end
    end

    it_behaves_like "fow entry"

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

    describe ".assimilate_player" do
      let(:rect1) { Rectangle.new(0, 0, 4, 4) }
      let(:rect2) { Rectangle.new(0, 0, 3, 3) }
      let(:rect3) { Rectangle.new(0, 0, 2, 2) }

      let(:player1) { player_w_alliance }
      let(:player2) { Factory.create(:player, :galaxy => player1.galaxy) }

      before(:each) do
        # Alliance 1
        FowGalaxyEntry.increase(rect1, player1)
        FowGalaxyEntry.increase(rect2, player1)

        # Player 2
        FowGalaxyEntry.increase(rect2, player2)
        FowGalaxyEntry.increase(rect3, player2)
      end

      it "should add all player entries to alliance pool" do
        FowGalaxyEntry.assimilate_player(alliance, player2)

        count_for_alliance(alliance.id).should == {
          rect1 => 1,
          rect2 => 2,
          rect3 => 1
        }
      end

      it "should fire event" do
        should_fire_event(
          Event::FowChange.new(player2, alliance),
          EventBroker::FOW_CHANGE, event_reason
        ) do
          FowGalaxyEntry.assimilate_player(alliance, player2)
        end
      end
    end

    describe ".throw_out_player" do
      let(:rect1) { Rectangle.new(0, 0, 4, 4) }
      let(:rect2) { Rectangle.new(0, 0, 3, 3) }
      let(:rect3) { Rectangle.new(0, 0, 2, 2) }

      let(:player1) { player_w_alliance }
      let(:player2) { Factory.create(:player, :galaxy => player1.galaxy) }

      before(:each) do
        # Alliance SS
        Factory.create(:fge_player, :rectangle => rect1,
          :alliance => alliance, :counter => 1)
        Factory.create(:fge_player, :rectangle => rect2,
          :alliance => alliance, :counter => 2)
        Factory.create(:fge_player, :rectangle => rect3,
          :alliance => alliance, :counter => 1)

        # P2 SS
        Factory.create(:fge_player, :rectangle => rect2,
          :player => player2, :counter => 1)
        Factory.create(:fge_player, :rectangle => rect3,
          :player => player2, :counter => 1)
      end

      it "should remove all player entries from alliance pool" do
        FowGalaxyEntry.throw_out_player(alliance, player2)

        count_for_alliance(alliance.id).should == {
          rect1 => 1,
          rect2 => 1
        }
      end

      it "should fire event" do
        should_fire_event(
          Event::FowChange.new(player2, alliance),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_GALAXY_ENTRY
        ) do
          FowGalaxyEntry.throw_out_player(alliance, player2)
        end
      end
    end
  end
end