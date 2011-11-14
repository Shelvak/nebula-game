# Non-Agression Pact. Established between two alliances to cease fire.
class Nap < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'Alliance'
  belongs_to :acceptor, :class_name => 'Alliance'

  # This +Nap+ has only been proposed. Other party hasn't responded yet.
  STATUS_PROPOSED = 0
  # This +Nap+ is established.
  STATUS_ESTABLISHED = 1
  # This +Nap+ has been rejected by other party and it's scheduled for
  # deletion. Another +Nap+ cannot be initiated while this one still exists.
  STATUS_REJECTED = 2
  # This +Nap+ is in process of being canceled. #expires_at will be set.
  STATUS_CANCELED = 3

  validates_uniqueness_of :acceptor_id, :scope => :initiator_id

  # Returns +Array+ of +Fixnum+ alliance ids that have naps with given
  # _alliance_id_. Required status of +Nap+ is given via _status_.
  def self.alliance_ids_for(alliance_id, status=STATUS_ESTABLISHED)
    get_rules([alliance_id], status)[alliance_id] || []
  end

  # Given _alliance_ids_ return a +Hash+ of +Nap+ rules with _status_.
  #
  # Rules hash looks like:
  # {
  #   alliance_id => [alliance_id, alliance_id, ...],
  #   ...
  # }
  #
  # Alliances in a set have naps with alliance in hash key.
  #
  def self.get_rules(alliance_ids, status=[STATUS_ESTABLISHED, STATUS_CANCELED])
    nap_rules = {}

    Nap.where(:status => status).where(
      "(initiator_id IN (?) OR acceptor_id IN (?))",
      alliance_ids, alliance_ids
    ).each do |nap|
      nap_rules[nap.initiator_id] ||= Set.new
      nap_rules[nap.acceptor_id] ||= Set.new

      nap_rules[nap.initiator_id].add nap.acceptor_id
      nap_rules[nap.acceptor_id].add nap.initiator_id
    end

    nap_rules.each do |alliance_id, set|
      nap_rules[alliance_id] = set.to_a
    end

    nap_rules
  end

  # Cancel +Nap+ by request of +Alliance+ with _initiator_id_. If
  # _initiator_id_ is supplied other party is notified about cancellation.
  #
  # TODO: create notification
  def cancel(initiator_id=nil)
    self.status = STATUS_CANCELED
    self.expires_at = CONFIG.evalproperty(
      'alliances.naps.cancellation_time'
    ).since
    CallbackManager.register(self, CallbackManager::EVENT_DESTROY,
      self.expires_at)
  end

  after_destroy :invoke_battles
  # TODO: spec
  def invoke_battles
    initiator_player_ids = Alliance.player_ids_for(initiator_id)
    acceptor_player_ids = Alliance.player_ids_for(acceptor_id)

    # Select all locations that have units from both, now opposing,
    # alliances.
    #
    # Check for combat in those locations.
    Unit.connection.select_all(%Q{
      SELECT `location_id`, `location_type`, `location_x`, `location_y`,
        COUNT(DISTINCT(
          IF(player_id IN (#{initiator_player_ids.join(",")}), 1, 2)
        )) as alliance_count
      FROM `#{Unit.table_name}`
      WHERE player_id IN (#{
        (initiator_player_ids + acceptor_player_ids).join(",")
      })
      GROUP BY `location_id`, `location_type`, `location_x`, `location_y`
      HAVING alliance_count = 2
    }).each do |row|
      Combat::LocationChecker.check_location(
        :location_id => row['location_id'],
        :location_type => row['location_type'],
        :location_x => row['location_x'],
        :location_y => row['location_y']
      )
    end
  end
end