# Notification for some event that happened.
#
# For _params_ formats see:
# * Notification#create_for_not_enough_resources
# * Notification#create_for_buildings_deactivated
# * Notification#create_for_combat
# * Notification#create_for_quest_started
# * Notification#create_for_quest_completed
#
class Notification < ActiveRecord::Base
  # These methods must be defined before the include.
  
  def self.notify_on_update?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier
  include Parts::Object

  belongs_to :player

  EVENT_NOT_ENOUGH_RESOURCES = 0
  EVENT_BUILDINGS_DEACTIVATED = 1
  EVENT_COMBAT = 2
  # Quest has been started.
  EVENT_QUEST_STARTED = 3
  # Quest has been completed.
  EVENT_QUEST_COMPLETED = 4

  COMBAT_WIN = Combat::Report::OUTCOME_WIN
  COMBAT_LOSE = Combat::Report::OUTCOME_LOSE
  COMBAT_TIE = Combat::Report::OUTCOME_TIE

  serialize :params
  default_scope :order => "`read` ASC, `created_at` DESC"

  protected
  before_save :set_timestamps
  def set_timestamps
    self.created_at ||= Time.now
    self.expires_at ||= self.created_at +
      CONFIG.evalproperty('notifications.expiration_time')
    true
  end

  after_update :update_related
  def update_related
    case event
    when EVENT_COMBAT
      CombatLog.update_all(
        ["expires_at=?", expires_at],
        ["sha1_id=? AND expires_at<?", self.params[:log_id], expires_at]
      )
    end

    true
  end

  def self.create_from_error(error)
    case error
    when NotEnoughResourcesAggregated
      constructor = error.constructor
      create_for_not_enough_resources(constructor.planet.player_id,
        constructor, error.constructables)
    else
      raise ArgumentError.new("Unknown error type '#{error.class}'!")
    end
  end

  # * Not enough resources (EVENT_NOT_ENOUGH_RESOURCES = 0)
  #  {
  #    :location => see Location#client_location.as_json,
  #    :constructor => Building#as_json,
  #    :constructables => {
  #      constructable.type => count
  #    },
  #    :coordinates => [
  #      [x1, y1],
  #      [x2, y2],
  #      ...
  #    ]
  #  }
  def self.create_for_not_enough_resources(player_id, constructor,
      constructables)
    model = new
    model.event = EVENT_NOT_ENOUGH_RESOURCES
    model.player_id = player_id

    model.params = {
      :location => constructor.planet.client_location.as_json,
      :constructor => constructor.as_json,
      :constructables => constructables.grouped_counts { |c| c.class.to_s },
      :coordinates => constructables.map do |c|
        case c
        when Building
          [c.x, c.y]
        else
          nil
        end
      end.compact
    }
    model.save!

    model
  end

  def self.group_building_change_counts(changes)
    changes.map { |i| i[0] }.grouped_counts { |building| building.type }
  end

  # * Buildings deactivated due to insufficient energy
  # (EVENT_BUILDINGS_DEACTIVATED = 1)
  #  {
  #    :location => see Location#client_location.as_json,
  #    :buildings => {
  #      # type => count
  #      "ZetiumExtractor" => 1,
  #      "MetalExtractor" => 3
  #    }
  #  }
  def self.create_for_buildings_deactivated(planet, changes)
    model = new
    model.event = EVENT_BUILDINGS_DEACTIVATED
    model.player_id = planet.player_id

    model.params = {
      :location => planet.client_location.as_json,
      :buildings => group_building_change_counts(changes)
    }
    model.save!

    model
  end

  # Creates notification for combat.
  #
  # - _player_ - Player that notification is being created for.
  # - _alliance_id_ - Alliance id as referenced in _alliance_players_.
  # - _alliance_players_ - Combat::NotificationHelpers#alliance_players.
  # - _combat_log_id_ - CombatLog object id for that combat.
  # - _location_attrs_ - Location#client_location.as_json.
  # - _outcome_ - Combat::OUTCOME_* constant.
  # - _yane_units_ - Yours/Alliance/Nap/Enemy grouped units. See
  # Combat::NotificationHelpers#group_to_yane for format.
  # - _leveled_up_ - Combat::NotificationHelpers#leveled_up_units.
  # - _statistics_ - Combat::NotificationHelpers#statistics_for_player.
  #
  # The created +Notification+ has these _params_:
  #
  # {
  #  :alliance_id => +Fixnum+,
  #  # Combat::NotificationHelpers#classify_alliances
  #  :alliances => {
  #     # Alliance (id 10)
  #     10 => {
  #       :name => "FooBar Heroes",
  #       :classification => CLASSIFICATION_FRIEND (0)
  #         || CLASSIFICATION_ENEMY (1)
  #         || CLASSIFICATION_NAP (2),
  #       :players => [
  #         {:id => 10, :name => "orc"},
  #         {:id => 11, :name => "undead"},
  #         {:id => nil, :name => nil}
  #       ],
  #     }
  #     ...
  #   },
  #  :log_id => +String+,
  #  # Location#client_location.as_json
  #  :location => {
  #    :type => Location::GALAXY || Location::SOLAR_SYSTEM ||
  #      Location::PLANET,
  #    :id => location_id,
  #    :x => location_x,
  #    :y => location_y,
  #    :name => name,
  #    :variation => variation,
  #    :solar_system_id => solar_system_id
  #  },
  #  # Combat::OUTCOME_WIN (0) || Combat::OUTCOME_LOSE (1)
  #   || Combat::OUTCOME_TIE (2) constant
  #  :outcome => outcome,
  #  # Combat::NotificationHelpers#group_to_yane
  #  :units => {
  #     :yours => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :alliance => {
  #       :alive => {"Building::Vulcan" => 1, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :nap => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :enemy => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     }
  #  },
  #  # Combat::NotificationHelpers#leveled_up_units
  #  :leveled_up => [
  #    {:type => "Unit::Trooper", :hp => 100, :level => "3"},
  #    ...
  #  ]
  #  # Combat::NotificationHelpers#statistics_for_player
  #  :statistics => {
  #    :damage_dealt_player => +Fixnum+,
  #    :damage_dealt_alliance => +Fixnum+,
  #    :damage_taken_player => +Fixnum+,
  #    :damage_taken_alliance => +Fixnum+,
  #    :xp_earned => +Fixnum+,
  #    :points_earned => +Fixnum+,
  #  }
  # }
  #
  def self.create_for_combat(player, alliance_id, alliances,
      combat_log_id, location_attrs, outcome, yane_units, leveled_up,
      statistics)
    model = new
    model.event = EVENT_COMBAT
    model.player_id = player.id

    model.params = {
      :alliance_id => alliance_id,
      :alliances => alliances,
      :log_id => combat_log_id,
      :location => location_attrs,
      :outcome => outcome,
      :units => yane_units,
      :leveled_up => leveled_up,
      :statistics => statistics
    }
    model.save!

    model   
  end

  # EVENT_QUEST_STARTED = 3
  #
  # params = {:id => quest_id}
  def self.create_for_quest_started(quest_progress)
    model = new(
      :event => EVENT_QUEST_STARTED,
      :player_id => quest_progress.player_id,
      :params => {:id => quest_progress.quest_id}
    )
    model.save!

    model
  end

  # EVENT_QUEST_COMPLETED = 4
  #
  # params = {:id => quest_id}
  def self.create_for_quest_completed(quest_progress)
    model = new(
      :event => EVENT_QUEST_COMPLETED,
      :player_id => quest_progress.player_id,
      :params => {:id => quest_progress.quest_id}
    )
    model.save!

    model
  end
end