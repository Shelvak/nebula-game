# Notification for some event that happened.
#
# For _params_ formats see:
# * Notification#create_for_not_enough_resources
# * Notification#create_for_buildings_deactivated
# * Notification#create_for_combat
# * Notification#create_for_quest_completed
# * Notification#create_for_exploration_finished
# * Notification#create_for_planet_annexed
# * Notification#create_for_alliance_invite
# * Notification#create_for_planet_protected
# * Notification#create_for_kicked_from_alliance
# * Notification#create_for_alliance_joined
# * Notification#create_for_market_offer_bought
# * Notification#create_for_vps_to_creds_conversion
# * Notification#create_for_alliance_owner_changed
# * Notification#create_for_technologies_changed
# * Notification#create_for_player_attached
# * Notification#create_for_ally_planet_boss_spawn
# * Notification#create_for_ally_planet_reinitiate_combat
# * Notification#create_for_units_claimed
#
class Notification < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  # These methods must be defined before the include.
  
  def self.notify_on_update?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier

  # Allow user to skip dispatching of the created notification.
  attr_accessor :skip_dispatch
  def notify_broker_create
    super unless skip_dispatch
  end

  include Parts::Object

  belongs_to :player

  # There were not enough resources to build things.
  EVENT_NOT_ENOUGH_RESOURCES = 0
  # Some buildings were deactivated because of insufficient energy.
  EVENT_BUILDINGS_DEACTIVATED = 1
  # There was combat.
  EVENT_COMBAT = 2
  # Achievement has been completed.
  EVENT_ACHIEVEMENT_COMPLETED = 3
  # Quest has been completed.
  EVENT_QUEST_COMPLETED = 4
  # Scientists came back from exploration.
  EVENT_EXPLORATION_FINISHED = 5
  # Either you have annexed a planet or your planet was annexed.
  EVENT_PLANET_ANNEXED = 6
  # You have received an alliance invitation.
  EVENT_ALLIANCE_INVITATION = 7
  # You have been kicked from alliance
  EVENT_ALLIANCE_KICK = 9
  # Player has joined alliance.
  EVENT_ALLIANCE_JOINED = 10
  # Some piece of market offer was bought.
  EVENT_MARKET_OFFER_BOUGHT = 11
  # Creds awarded for victory points.
  EVENT_VPS_CONVERTED_TO_CREDS = 12
  # Alliance owner has changed.
  EVENT_ALLIANCE_OWNER_CHANGED = 13
  # Technologies had their scientists modified or were paused.
  EVENT_TECHNOLOGIES_CHANGED = 14
  # Player has been attached to the galaxy.
  EVENT_PLAYER_ATTACHED = 15
  # Alliance member has spawned boss in your planet.
  EVENT_ALLY_PLANET_BOSS_SPAWN = 16
  # Alliance member has reinitiated combat in your planet.
  EVENT_ALLY_PLANET_REINITIATE_COMBAT = 17
  # Non-combat units claimed in other planet.
  EVENT_UNITS_CLAIMED = 18

  serialize :params, JSON
  default_scope order("`read` ASC, `created_at` DESC")

  protected
  before_save do
    self.created_at ||= Time.now
    self.expires_at ||= self.created_at + Cfg.notification_expiration_time

    true
  end

  after_save do
    CallbackManager.register_or_update(
      self, CallbackManager::EVENT_DESTROY, self.expires_at
    )
  end

  DESTROY_SCOPE = DScope.low_prio
  def self.destroy_callback(notification); notification.destroy!; end

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
  #    :location => see ClientLocation#as_json,
  #    :constructor_type => type of constructor (e.g. Barracks),
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
      :constructor_type => constructor.type,
      :constructables => constructables.grouped_counts { |c| c.class.to_s },
      # Coordinates to delete ghosted buildings?
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

  # * Buildings deactivated due to insufficient energy
  # (EVENT_BUILDINGS_DEACTIVATED = 1)
  #  {
  #    :location => see ClientLocation#as_json,
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

    buildings = changes.map do |building, state, old_value, new_value|
      building
    end.grouped_counts(&:type)

    model.params = {
      :location => planet.client_location.as_json,
      :buildings => buildings
    }
    model.save!

    model
  end

  # Creates notification for combat.
  #
  # - _player_id_ - Player ID that notification is being created for.
  # - _alliance_id_ - Alliance id as referenced in _alliance_players_.
  # - _alliance_ - SpaceMule#combat response['classified_alliances'][player_id]
  # - _combat_log_id_ - CombatLog object id for that combat.
  # - _location_attrs_ - ClientLocation#as_json.
  # - _building_type_ - see below.
  # - _building_attacker_id_ - see below.
  # - _outcome_ - Combat::OUTCOME_* constant.
  # - _yane_units_ - SpaceMule#combat response['yane'][player_id]
  # - _leveled_up_ - Combat::NotificationHelpers#leveled_up_units.
  # - _statistics_ - SpaceMule#combat response['statistics'][player_id]
  # - _push_notification_ - should notification be dispatched to client.
  #
  # The created +Notification+ has these _params_:
  #
  # {
  #  :alliance_id => +Fixnum+,
  #  :alliances => {
  #     # Alliance (id 10)
  #     10 => {
  #       'name' => String | null,
  #       'classification' => CLASSIFICATION_FRIEND (0)
  #         || CLASSIFICATION_ENEMY (1)
  #         || CLASSIFICATION_NAP (2),
  #       'players' => [ [id: Int, name: String] | null ]
  #     }
  #     ...
  #   },
  #  :log_id => +String+,
  #  :location => ClientLocation#as_json,
  #  # If combat was initiated on NPC building, :location will be planet,
  #  # and :building_type will be some String (without "Building::"). Otherwise
  #  # it is nil.
  #  :building_type => nil | building type (String, e.g. NpcHall)
  #  # Player ID who initiated building attack.
  #  :building_attacker_id => nil | player_id (Fixnum)
  #  # Combat::OUTCOME_WIN (0) || Combat::OUTCOME_LOSE (1)
  #   || Combat::OUTCOME_TIE (2) constant
  #  :outcome => outcome,
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
  #  :statistics => {
  #    :damage_dealt_player => +Fixnum+,
  #    :damage_dealt_alliance => +Fixnum+,
  #    :damage_taken_player => +Fixnum+,
  #    :damage_taken_alliance => +Fixnum+,
  #    :xp_earned => +Fixnum+,
  #    :points_earned => +Fixnum+,
  #    :victory_points_earned => +Fixnum+,
  #    :creds_earned => +Fixnum+
  #  },
  #  :resources => {
  #    :metal => +Fixnum+,
  #    :energy => +Fixnum+,
  #    :zetium => +Fixnum+
  #  }
  # }
  #
  def self.create_for_combat(player_id, args)
    typesig binding, Fixnum, Hash
    args.ensure_options!(required: {
      alliance_id: Fixnum, alliances: Hash, combat_log_id: String,
      location_attrs: Hash, building_type: [String, NilClass],
      building_attacker_id: [Fixnum, NilClass],
      outcome: Fixnum, yane_units: Hash, leveled_up_units: Array,
      statistics: Hash, wreckages: Hash, push_notification: Boolean
    })

    model = new
    model.event = EVENT_COMBAT
    model.player_id = player_id

    model.params = {
      'alliance_id' => args[:alliance_id].as_json,
      'alliances' => args[:alliances].as_json,
      'log_id' => args[:combat_log_id].as_json,
      'location' => args[:location_attrs].as_json,
      'building_type' => args[:building_type],
      'building_attacker_id' => args[:building_attacker_id],
      'outcome' => args[:outcome].as_json,
      'units' => args[:yane_units].as_json,
      'leveled_up' => args[:leveled_up_units].as_json,
      'statistics' => args[:statistics].as_json,
      'resources' => args[:wreckages].as_json
    }
    model.skip_dispatch = ! args[:push_notification]
    model.save!

    model   
  end

  # EVENT_ACHIEVEMENT_COMPLETED = 3
  #
  # params = {
  #   :achievement => Quest#get_achievement
  # }
  def self.create_for_achievement_completed(quest_progress)
    achievement = Quest.get_achievement(quest_progress.quest_id,
      quest_progress.player_id)
    model = new(
      :event => EVENT_ACHIEVEMENT_COMPLETED,
      :player_id => quest_progress.player_id,
      :params => {:achievement => achievement}
    )
    model.save!

    model
  end

  # EVENT_QUEST_COMPLETED = 4
  #
  # params = {
  #   :finished => quest_id (Fixnum),
  #   :started => quest_ids (Fixnum[])
  # }
  def self.create_for_quest_completed(quest_progress, started_quests)
    model = new(
      :event => EVENT_QUEST_COMPLETED,
      :player_id => quest_progress.player_id,
      :params => {
        :finished => quest_progress.quest_id,
        :started => started_quests.map(&:id)
      }
    )
    model.save!

    model
  end

  # EVENT_EXPLORATION_FINISHED = 5
  #
  # params = {
  #   :location => ClientLocation#as_json,
  #   :rewards => Rewards#as_json
  # }
  def self.create_for_exploration_finished(planet, rewards)
    model = new(
      :event => EVENT_EXPLORATION_FINISHED,
      :player_id => planet.player_id,
      :params => {
        :location => planet.client_location.as_json,
        :rewards => rewards.as_json
      }
    )
    model.save!

    model
  end

  # EVENT_PLANET_ANNEXED = 6
  #
  # params = {
  #   :planet => ClientLocation#as_json,
  #   :owner => Player#as_json(:mode => :minimal) | nil,
  #   :outcome => Fixnum | nil (whether you lost or won battle for that 
  #   planet, nil if no battle was fought)
  # }
  #
  # Variations:
  #   with owner:
  #     outcome win: player conquered other players planet.
  #     outcome lose: player or his ally lost control of planet.
  #   owner == nil:
  #     outcome win: player conquered this planet in a combat from NPC
  #     outcome nil: player arrived at empty annexable planet
  #
  def self.create_for_planet_annexed(player_id, planet, outcome)
    model = new(
      :event => EVENT_PLANET_ANNEXED,
      :player_id => player_id,
      :params => {
        :planet => planet.client_location.as_json,
        :owner => planet.player \
          ? planet.player.as_json(:mode => :minimal) : nil,
        :outcome => outcome,
      }
    )
    model.save!

    model
  end

  # EVENT_ALLIANCE_INVITATION = 7
  #
  # params = {
  #   :alliance => Alliance#as_json(:mode => :minimal)
  # }
  def self.create_for_alliance_invite(alliance, player)
    # Ensure we don't get duplicate invitations.
    where(:player_id => player.id, :event => EVENT_ALLIANCE_INVITATION).each do
      |notification|

      return notification \
        if notification.params['alliance']['id'] == alliance.id
    end

    model = new(
      :event => EVENT_ALLIANCE_INVITATION,
      :player_id => player.id,
      :params => {:alliance => alliance.as_json(:mode => :minimal)}
    )
    model.save!

    model
  end
  
  # EVENT_ALLIANCE_KICK = 9
  #
  # params = {
  #   :alliance => Alliance#as_json(:mode => :minimal)
  # }
  def self.create_for_kicked_from_alliance(alliance, player)
    model = new(
      :event => EVENT_ALLIANCE_KICK,
      :player_id => player.id,
      :params => {:alliance => alliance.as_json(:mode => :minimal)}
    )
    model.save!

    model    
  end
  
  # EVENT_ALLIANCE_JOINED = 10
  #
  # params = {
  #   :alliance => Alliance#as_json(:mode => :minimal),
  #   :player => Player#as_json(:mode => :minimal)
  # }
  def self.create_for_alliance_joined(alliance, player)
    alliance.players.map do |alliance_player|
      if alliance_player == player
        nil
      else
        model = new(
          :event => EVENT_ALLIANCE_JOINED,
          :player_id => alliance_player.id,
          :params => {
            :alliance => alliance.as_json(:mode => :minimal),
            :player => player.as_json(:mode => :minimal)
          }
        )
        model.save!

        model
      end
    end.compact
  end
  
  # EVENT_MARKET_OFFER_BOUGHT = 11
  #
  # params = {
  #   :buyer => Player#as_json(:mode => :minimal),
  #   :planet => ClientLocation#as_json,
  #   :from_kind => Fixnum (resource which buyer has bought),
  #   :amount => Fixnum (amount which buyer has bought),
  #   :to_kind => Fixnum (resource which buyer has paid with),
  #   :cost => Fixnum (amount which buyer has paid),
  #   :amount_left => Fixnum (amount left in the offer. Offer is depleted if
  #   this is 0)
  # }
  def self.create_for_market_offer_bought(market_offer, buyer, amount, cost)
    model = new(
      :event => EVENT_MARKET_OFFER_BOUGHT,
      :player_id => market_offer.player_id,
      :params => {
        :buyer => buyer.as_json(:mode => :minimal),
        :planet => market_offer.planet.client_location.as_json,
        :from_kind => market_offer.from_kind,
        :amount => amount,
        :to_kind => market_offer.to_kind,
        :cost => cost,
        :amount_left => market_offer.from_amount
      }
    )
    model.save!

    model
  end

  # EVENT_VICTORY_POINTS_AWARDED = 12
  #
  # params = {
  #   :personal_creds => Fixnum (Amount of creds awarded personally),
  #   :total_alliance_creds => Fixnum | nil (Amount of creds for all alliance,
  #     nil if not in alliance),
  #   :alliance_creds_per_player => Fixnum | nil (Amount of creds for all
  #     alliance, nil if not in alliance),
  # }
  def self.create_for_vps_to_creds_conversion(player_id, personal_creds,
      total_alliance_creds, alliance_creds_per_player)
    model = new(
      :event => EVENT_VPS_CONVERTED_TO_CREDS,
      :player_id => player_id,
      :params => {
        :personal_creds => personal_creds,
        :total_alliance_creds => total_alliance_creds,
        :alliance_creds_per_player => alliance_creds_per_player
      }
    )
    model.save!

    model
  end

  # EVENT_ALLIANCE_OWNER_CHANGED = 13
  #
  # params = {
  #   :alliance => Alliance#as_json(:mode => :minimal)
  #   :old_owner => Player#minimal,
  #   :new_owner => Player#minimal,
  # }
  def self.create_for_alliance_owner_changed(player_id, alliance, old_owner,
      new_owner)
    model = new(
      :event => EVENT_ALLIANCE_OWNER_CHANGED,
      :player_id => player_id,
      :params => {
        :alliance => alliance,
        :old_owner => old_owner,
        :new_owner => new_owner
      }
    )
    model.save!

    model
  end

  # EVENT_TECHNOLOGIES_CHANGED = 14
  #
  # params = {
  #   :changed => [
  #     [technology_name (String), old_scientists (Fixnum),
  #       new_scientists (Fixnum)],
  #     ["GroundDamage", 100, 80],
  #     ...
  #   ],
  #   :paused => [technology_name (String), ..., ...]
  # }
  #
  # _changes_ must be a result from +Reducer+.
  #
  # [
  #   [technology, Reducer::RELEASED] |
  #   [technology, Reducer::CHANGED, old_scientists, new_scientists]
  # ]
  #
  def self.create_for_technologies_changed(player_id, changes)
    changed, paused = changes.each_with_object([[], []]) do
      |(technology, state, old_scientists, new_scientists), (c, p)|

      c << [technology[:type], old_scientists, new_scientists] \
        if state == Reducer::CHANGED
      p << technology[:type] if state == Reducer::RELEASED
    end

    model = new(
      :event => EVENT_TECHNOLOGIES_CHANGED,
      :player_id => player_id,
      :params => {
        :changed => changed,
        :paused => paused
      }
    )
    model.save!

    model
  end

  # EVENT_PLAYER_ATTACHED = 15
  #
  # params => {}
  def self.create_for_player_attached(player_id)
    model = new(
      :event => EVENT_PLAYER_ATTACHED,
      :player_id => player_id,
      :params => {}
    )
    # Skip dispatch because this notification is created when player is logging
    # in, before initialization.
    model.skip_dispatch = true
    model.save!

    model
  end

  # EVENT_ALLY_PLANET_BOSS_SPAWN = 16
  #
  # params => {
  #   # Player who spawned planet boss into your planet.
  #   :spawner => Player#as_json(mode: :minimal),
  #   # Planet to which the boss was spawned too.
  #   :planet => ClientLocation#as_json
  # }
  def self.create_for_ally_planet_boss_spawn(planet, spawner)
    typesig binding, SsObject::Planet, Player

    model = new(
      :event => EVENT_ALLY_PLANET_BOSS_SPAWN,
      :player_id => planet.player_id,
      :params => {
        :spawner => spawner.as_json(mode: :minimal),
        :planet => planet.client_location.as_json
      }
    )
    model.save!

    model
  end

  # EVENT_ALLY_PLANET_REINITIATE_COMBAT = 17
  #
  # params => {
  #   # Player who reinitiated combat in your planet.
  #   :reinitiator => Player#as_json(mode: :minimal),
  #   # Planet in which combat was reinitiated.
  #   :planet => ClientLocation#as_json
  # }
  def self.create_for_ally_planet_reinitiate_combat(planet, reinitiator)
    typesig binding, SsObject::Planet, Player

    model = new(
      :event => EVENT_ALLY_PLANET_REINITIATE_COMBAT,
      :player_id => planet.player_id,
      :params => {
        :reinitiator => reinitiator.as_json(mode: :minimal),
        :planet => planet.client_location.as_json
      }
    )
    model.save!

    model
  end

  # EVENT_UNITS_CLAIMED = 18
  #
  # params => {
  #   # Planet in which combat was reinitiated.
  #   :planet => ClientLocation#as_json,
  #   # How much of which units were claimed.
  #   :unit_counts => {type (String, e.g. Trooper) => count (Fixnum)}
  # }
  def self.create_for_units_claimed(player_id, planet, unit_counts)
    typesig binding, Fixnum, SsObject::Planet, Hash

    model = new(
      event: EVENT_UNITS_CLAIMED,
      player_id: player_id,
      params: {
        planet: planet.client_location.as_json,
        unit_counts: unit_counts
      }
    )
    model.save!

    model
  end
end
