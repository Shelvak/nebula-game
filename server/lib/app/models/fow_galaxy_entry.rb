# Class that determines visibility of galaxy sectors. In these sectors
# units can be seen by +Player+ or +Alliance+.
#
class FowGalaxyEntry < ActiveRecord::Base
  belongs_to :galaxy

  include Parts::FowEntry

  # Retrieve +FowGalaxyEntry+ by given coordinates.
  scope :by_coords, Proc.new { |x, y|
    {
      :conditions => [
        "(? BETWEEN x AND x_end) AND (? BETWEEN y AND y_end)",
        x, y
      ]
    }
  }

  composed_of :rectangle, :mapping => Rectangle::MAPPING

  def inspect
    "<FowGalaxyEntry id: #{id}, galaxy_id: #{galaxy_id}, #{
      alliance_id \
        ? "aid: #{alliance_id.inspect}" \
        : "pid: #{player_id.inspect}"
    }, rect: [#{x}, #{y}] => [#{x_end}, #{y_end}], counter: #{counter}>"
  end

  def as_json(options=nil)
    {"x" => x, "y" => y, "x_end" => x_end, "y_end" => y_end}
  end

  class << self
    # Returns +Player+ ids for +GalaxyPoint+ in +Galaxy+ at coordinates 
    # x, y.
    def observer_player_ids(galaxy_id, x, y)
      super(
        sanitize_sql_for_conditions([
          "galaxy_id=? AND (? BETWEEN x AND x_end) AND
            (? BETWEEN y AND y_end)",
          galaxy_id, x, y
        ])
      )
    end

    # Returns if given spot is visible.
    # TODO: spec
    def visible?(player, x, y)
      self.for(player).by_coords(x, y).first.nil? ? false : true
    end

    # Creation/deletion

    # Create or update row for given zone with _kind_ => _id_ and
    # increase counter by _increasement_. See #update_record for return
    # value.
    #
    # _kind_ can be either 'player_id' or 'alliance_id'.
    #
    def increase_for_kind(rectangle, galaxy_id, kind, id, incrementation=1)
      check_params = {
        :x => rectangle.x,
        :x_end => rectangle.x_end,
        :y => rectangle.y,
        :y_end => rectangle.y_end,
        kind => id
      }
      create_params = check_params.merge(:galaxy_id => galaxy_id)

      update_record(check_params, create_params, incrementation)
    end

    # Create an entry for _player_ at zone _rectangle_. Increase counter
    # by _increasement_.
    #
    # This also creates entry for +Alliance+ if _player_ is in one.
    def increase(rectangle, player, increasement=1)
      status = increase_for_kind(
        rectangle, player.galaxy_id, 'player_id', player.id,
        increasement)
      increase_for_kind(
        rectangle, player.galaxy_id, 'alliance_id',
        player.alliance_id, increasement) \
        unless player.alliance_id.nil?

      should_dispatch = status == :created || status == :destroyed

      # Dispatch event to send new vision to players.
      dispatch_changed(player) if should_dispatch

      should_dispatch
    end
    
    # Dispatches changed for galaxy map, which updates whole galaxy map in
    # client.
    def dispatch_changed(player, alliance=nil)
      EventBroker.fire(
        FowChangeEvent.new(player, alliance || player.alliance),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_GALAXY_ENTRY
      )
    end

    # Deletes entry for _player_ at zone _rectangle_. Also removes entry
    # for +Alliance+ if _player_ is in one.
    def decrease(rectangle, player, decrement=1)
      # Decrement counter
      increase(rectangle, player, -decrement)
    end

    # Assimilate or throw out player
    #
    # Multiply _counter_ by _modifier_ before adding.
    def change_player(alliance_id, player_id, modifier)
      transaction do
        find(:all, :conditions => {:player_id => player_id}).each do |entry|
          increase_for_kind(entry.rectangle, entry.galaxy_id,
            'alliance_id', alliance_id,
            entry.counter * modifier)
        end
      end
    end

    # Add all entries currently belonging to player to alliance pool.
    def assimilate_player(alliance, player)
      change_player(alliance.id, player.id, 1)
      dispatch_changed(player, alliance)
    end

    # Remove all player entries from alliance pool.
    def throw_out_player(alliance, player)
      change_player(alliance.id, player.id, -1)
      dispatch_changed(player, alliance)
    end

    # Returns SQL for conditions that limits things on table identified by
    # _table_name_ to limits of _fow_entries_.
    #
    # Only useful for units!
    def conditions(fow_entries)
      return "1=0" if fow_entries.blank?

      "(" + conditions_for_coordinates(fow_entries, "location_") +
        ") AND (#{sanitize_sql_for_conditions(
          [
            "location_type=? AND location_id=?",
            Location::GALAXY,
            fow_entries[0].galaxy_id
          ]
      )})"
    end

    # Returns conditions string that limits coordinates to areas defined in
    # _fow_entries_.
    def conditions_for_coordinates(fow_entries, prefix="")
      fow_entries.map do |entry|
        sanitize_sql_for_conditions(
          [
            "(#{prefix}x BETWEEN ? AND ? AND #{prefix}y BETWEEN ? AND ?)",
            entry.x, entry.x_end,
            entry.y, entry.y_end
          ]
        )
      end.join(" OR ")
    end
  end
end