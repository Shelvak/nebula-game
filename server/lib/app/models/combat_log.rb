require 'digest/sha1'

# Dumb object for storing Combat logs. Main purpose of this object is to
# send it to client for replays.
class CombatLog < ActiveRecord::Base
  DScope = Dispatcher::Scope

  # Configuration keys embedded into replay info so it could be replayed
  # later.
  REPLAY_INFO_CONFIG_REGEXP = /^(
    combat\.parallel\.count$
    |
    (buildings|units)\..+(kind|hp|guns)$
    |
    ui\.
  )/x

  custom_serialize :info,
    :serialize => lambda { |info| JSON.generate(info) },
    :unserialize => lambda { |serialized| JSON.parse(serialized) }

  # All the data needed to play back combat replay.
  def self.replay_info(client_location, alliances, nap_rules, outcomes, log)
    typesig binding, Hash, Hash, Hash, Hash, Hash

    {
      "location" => client_location,
      "alliances" => alliances.as_json,
      "nap_rules" => nap_rules.as_json,
      "outcomes" => outcomes.as_json,
      "log" => log.as_json,
      "config" => CONFIG.filter(REPLAY_INFO_CONFIG_REGEXP)
    }
  end

  # Is this player_id a winner in given battle?
  def self.winner?(info, player_id)
    winner_index = (info[:winner_index] || info["winner_index"])
    return false if winner_index.nil?

    (info[:alliances] || info["alliances"])[winner_index].each do |player_hash|
      return true if (player_hash[:id] || player_hash["id"]) == player_id
    end

    false
  end

  # Create CombatLog from combat information.
  #
  # Use this method instead of creating this class manually with new.
  #
  def self.create_from_combat!(log_report)
    log = new

    log.sha1_id = Digest::SHA1.hexdigest(
      "%s-%s-%05d" % [
        log_report[:alliances].inspect,
        Time.now.to_f.to_s,
        rand(100000)
      ]
    )
    log.info = log_report

    log.save!

    CallbackManager.register(
      log, CallbackManager::EVENT_DESTROY,
      Cfg.combat_log_expiration_time.from_now
    )

    log
  end

  DESTROY_SCOPE = DScope.low_prio
  def self.destroy_callback(combat_log); combat_log.destroy!; end
end