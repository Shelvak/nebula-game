class SsObject::Planet < SsObject
  belongs_to :player
  scope :for_player, Proc.new { |player|
    player_id = player.is_a?(Player) ? player.id : player

    {:conditions => {:player_id => player_id}}
  }

  # Foreign keys take care of the destruction
  has_many :tiles
  has_many :folliages
  has_many :buildings
  has_many :units,
    :finder_sql => %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `player_id` IS NOT NULL AND
    `location_type`=#{Location::SS_OBJECT} AND `location_id`=#\{id\} AND
    `location_x` IS NULL AND `location_y` IS NULL}

  # Options:
  # * :resources => true to include resources
  # * :view => true to include properties necessary to view planet.
  def as_json(options=nil)
    additional = {:player => player, :name => name}
    if options
      if options[:resources]
        %w{metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update energy_diminish_registered}.each do |attr|
          additional[attr.to_sym] = read_attribute(attr)
        end
      end

      if options[:view]
        additional[:width] = width
        additional[:height] = height
      end
    end
    
    super(options).merge(additional)
  end

  def landable?; true; end

  def observer_player_ids
    (player.nil? ? [] : player.friendly_ids) |
      Unit.player_ids_in_location(self)
  end

  before_save :update_fow_ss_entries, :if => Proc.new {
    |r| r.player_id_changed? }
  # Update FOW SS Entries to ensure that we see SS with our planets there
  # even if there are no radar coverage.
  def update_fow_ss_entries
    FowSsEntry.change_planet_owner(self)
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_CHANGED)
    true
  end

  after_save :update_resources_entry
  def update_resources_entry
    if player_id
      # Update resources entry `last_update` when player is assigned
      self.class.update_all(
        "last_resources_update=NOW()",
        ["id=? AND last_resources_update IS NULL", id]
      )
    end
  end
end