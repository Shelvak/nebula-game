# Class that determines visibility of galaxy sectors. In these sectors
# units can be seen by +Player+ or +Alliance+.
#
class FowGalaxyEntry < ActiveRecord::Base
  include Parts::WithLocking

  # FK :dependent => :destroy_all
  belongs_to :galaxy
  # FK :dependent => :destroy_all
  belongs_to :player

  # TODO: spec
  scope :for, lambda { |player| where(:player_id => player.friendly_ids) }

  # Retrieve +FowGalaxyEntry+ by given coordinates.
  scope :by_coords, lambda { |x, y|
    where("(? BETWEEN x AND x_end) AND (? BETWEEN y AND y_end)", x, y)
  }

  composed_of :rectangle, :mapping => Rectangle::MAPPING

  def inspect
    "<FowGalaxyEntry id: #{id}, galaxy_id: #{galaxy_id
    }, pid: #{player_id.inspect}, rect: [#{x}, #{y}] => [#{x_end}, #{y_end
    }], counter: #{counter}>"
  end

  def as_json(options=nil)
    {"x" => x, "y" => y, "x_end" => x_end, "y_end" => y_end}
  end

  class << self
    # Returns +Player+ ids for +GalaxyPoint+ in +Galaxy+ at coordinates
    # x, y.
    #
    # TODO: spec
    def observer_player_ids(galaxy_id, x, y)
      # Player ids that see that spot.
      player_ids = without_locking do
        select("DISTINCT(`player_id`)").
          where(galaxy_id: galaxy_id).
          where("? BETWEEN `x` AND `x_end`", x).
          where("? BETWEEN `y` AND `y_end`", y).
          c_select_values
      end

      Player.join_alliance_ids(player_ids)
    end

    # Returns if given spot is visible.
    # TODO: spec
    def visible?(player, x, y)
      ! self.for(player).by_coords(x, y).first.nil?
    end

    # Returns SQL for conditions that limits things on table identified by
    # _table_name_ to limits of _fow_entries_.
    #
    # Only useful for units!
    def conditions(fow_entries, prefix="location_")
      return "1=0" if fow_entries.blank?

      "(" + conditions_for_coordinates(fow_entries, prefix) +
        ") AND (#{sanitize_sql_for_conditions(
          ["#{prefix}galaxy_id=?", fow_entries[0].galaxy_id]
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

    # Creation/deletion

    # Create an entry for _player_ at zone _rectangle_. Increase counter
    # by _increment_.
    #
    # This also creates entry for +Alliance+ if _player_ is in one.
    def increase(rectangle, player, increment=1)
      typesig binding, Rectangle, Player, Fixnum

      status = increase_impl(
        rectangle, player.galaxy_id, player.id, increment
      )

      should_dispatch = status == :created || status == :destroyed

      # Dispatch event to send new vision to players.
      dispatch_changed(player) if should_dispatch

      should_dispatch
    end

    # Deletes entry for _player_ at zone _rectangle_. Also removes entry
    # for +Alliance+ if _player_ is in one.
    def decrease(rectangle, player, decrement=1)
      # Decrement counter
      increase(rectangle, player, -decrement)
    end
    
    # Dispatches changed for galaxy map, which updates whole galaxy map in
    # client.
    def dispatch_changed(player, alliance=nil)
      typesig binding, Player, [NilClass, Alliance]

      EventBroker.fire(
        Event::FowChange.new(player, alliance || player.alliance),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_GALAXY_ENTRY
      )
    end

  private

    # Create or update row for given zone and
    # increase counter by _incrementation_.
    #
    # Returns :created if record was created.
    # Returns :updated if record was updated.
    # Returns :destroyed if record was destroyed.
    # Returns false if nothing was done.
    #
    def increase_impl(rectangle, galaxy_id, player_id, incrementation=1)
      params = {
        galaxy_id: galaxy_id, player_id: player_id,
        x: rectangle.x, x_end: rectangle.x_end,
        y: rectangle.y, y_end: rectangle.y_end,
      }

      count = select("`counter`").where(params).c_select_value

      if count.nil?
        return false if incrementation < 0

        # Record does not exist, create it
        params[:counter] = incrementation
        connection.execute("INSERT INTO `#{table_name}` SET #{
          sanitize_sql_for_assignment(params)}")

        :created
      else
        value = count.to_i + incrementation
        if value > 0
          # Just update value
          where(params).update_all("`counter`=#{value}")

          :updated
        else
          # Destroy record
          where(params).delete_all

          :destroyed
        end
      end
    end
  end
end