require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe FowGalaxyEntry do
  describe ".conditions" do
    it "should return false condition if entries are blank" do
      FowGalaxyEntry.conditions([]).should == "1=0"
    end

    it "should return conditions joined by OR" do
      fge1 = Factory.create(:fow_galaxy_entry, :x => 0, :x_end => 3,
        :y => 0, :y_end => 6)
      fge2 = Factory.create(:fow_galaxy_entry, :x => -3, :x_end => 3,
        :y => -2, :y_end => 6, :galaxy => fge1.galaxy)

      FowGalaxyEntry.conditions([fge1, fge2]).should == \
        "(" +
          "(location_x BETWEEN #{fge1.x} AND #{fge1.x_end} AND " +
          "location_y BETWEEN #{fge1.y} AND #{fge1.y_end}) OR " +
          "(location_x BETWEEN #{fge2.x} AND #{fge2.x_end} AND " +
          "location_y BETWEEN #{fge2.y} AND #{fge2.y_end})" +
        ") AND (" +
          "location_type=#{Location::GALAXY} AND " +
          "location_id=#{fge1.galaxy_id}" +
        ")"
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
        model = Factory.create :fow_galaxy_entry,
          :rectangle => Rectangle.new(*rectangle)
        FowGalaxyEntry.by_coords(*coords).scoped_by_galaxy_id(
          model.galaxy_id).first.should == model
      end
    end
  end

  describe "as json" do
    before(:each) do
      @model = Factory.create(:fow_galaxy_entry)
    end

    @required_fields = %w{x y x_end y_end}
    @ommited_fields = %w{id player_id alliance_id counter}
    it_should_behave_like "to json"
  end

  describe "fow entry" do
    before(:each) do
      @short_factory_name = :fge
      @alliance = Factory.create(:alliance)
      @player = Factory.create(:player, :alliance => @alliance)
      @player_id = @player.id
      @rectangle = Rectangle.new(0, 0, 4, 4)

      @klass = FowGalaxyEntry
      @event_reason = EventBroker::REASON_GALAXY_ENTRY
      @first_arg = @rectangle
      @conditions = {
        :x => @rectangle.x,
        :x_end => @rectangle.x_end,
        :y => @rectangle.y,
        :y_end => @rectangle.y_end,
      }
    end

    it_should_behave_like "fow entry"

    it "should fire event if destroyed" do
      @klass.increase(@first_arg, @player, 2)
      should_fire_event(kind_of(FowChangeEvent),
          EventBroker::FOW_CHANGE, @event_reason) do
        @klass.decrease(@first_arg, @player, 2)
      end
    end

    def count_for_alliance(alliance_id)
      counters = {}
      FowGalaxyEntry.find(:all,
        :conditions => {:alliance_id => alliance_id}
      ).each do |entry|
        rectangle = Rectangle.new(entry.x, entry.y, entry.x_end,
          entry.y_end)
        counters[rectangle.as_json] = entry.counter
      end

      counters
    end

    describe ".assimilate_player" do
      before(:each) do
        @rect1 = Rectangle.new(0, 0, 4, 4)
        @rect2 = Rectangle.new(0, 0, 3, 3)
        @rect3 = Rectangle.new(0, 0, 2, 2)

        @player1 = @player
        @player2 = Factory.create(:player, :galaxy => @player1.galaxy)

        # Alliance 1
        FowGalaxyEntry.increase(@rect1, @player1)
        FowGalaxyEntry.increase(@rect2, @player1)

        # Player 2
        FowGalaxyEntry.increase(@rect2, @player2)
        FowGalaxyEntry.increase(@rect3, @player2)
      end

      it "should add all player entries to alliance pool" do
        FowGalaxyEntry.assimilate_player(@player1.alliance, @player2)

        count_for_alliance(@player1.alliance_id).should == {
          @rect1.as_json => 1,
          @rect2.as_json => 2,
          @rect3.as_json => 1
        }
      end

      it "should fire event" do
        should_fire_event(FowChangeEvent.new(@player2, @player1.alliance),
            EventBroker::FOW_CHANGE,
            EventBroker::REASON_GALAXY_ENTRY) do
          FowGalaxyEntry.assimilate_player(@player1.alliance,
            @player2)
        end
      end
    end

    describe ".throw_out_player" do
      before(:each) do
        @rect1 = Rectangle.new(0, 0, 4, 4)
        @rect2 = Rectangle.new(0, 0, 3, 3)
        @rect3 = Rectangle.new(0, 0, 2, 2)

        @player1 = @player
        @player2 = Factory.create(:player, :galaxy => @player1.galaxy)

        # Alliance SS
        Factory.create(:fow_galaxy_entry, :rectangle => @rect1,
          :alliance => @player1.alliance, :counter => 1)
        Factory.create(:fow_galaxy_entry, :rectangle => @rect2,
          :alliance => @player1.alliance, :counter => 2)
        Factory.create(:fow_galaxy_entry, :rectangle => @rect3,
          :alliance => @player1.alliance, :counter => 1)

        # P2 SS
        Factory.create(:fow_galaxy_entry, :rectangle => @rect2,
          :player => @player2, :counter => 1)
        Factory.create(:fow_galaxy_entry, :rectangle => @rect3,
          :player => @player2, :counter => 1)
      end

      it "should remove all player entries from alliance pool" do
        FowGalaxyEntry.throw_out_player(@player1.alliance, @player2)

        count_for_alliance(@player1.alliance_id).should == {
          @rect1.as_json => 1,
          @rect2.as_json => 1
        }
      end

      it "should fire event" do
        should_fire_event(
          FowChangeEvent.new(@player2, @player1.alliance),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_GALAXY_ENTRY
        ) do
          FowGalaxyEntry.throw_out_player(@player1.alliance, @player2)
        end
      end
    end
  end
end