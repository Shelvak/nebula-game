require 'digest/sha1'

# Dumb object for storing Combat logs. Main purpose of this object is to
# send it to client for replays.
class CombatLog < ActiveRecord::Base
  set_primary_key :sha1_id

  # Is this player_id a winner in given battle?
  def self.winner?(info, player_id)
    winner_index = info[:winner_index]
    return false if winner_index.nil?

    info[:alliances][winner_index].each do |player_hash|
      return true if player_hash[:id] == player_id
    end

    false
  end

  # Create CombatLog from combat information.
  #
  # Use this method instead of creating this class manually with new.
  #
  def self.create_from_combat!(log_report)
    log = new

    log.id = Digest::SHA1.hexdigest(
      "%s-%s-%05d" % [
        log_report[:alliances].inspect,
        Time.now.to_f.to_s,
        rand(100000)
      ]
    )
    log.info = log_report.to_json
    log.expires_at = Time.now + CONFIG.evalproperty(
      'notifications.expiration_time')

    log.save!

    log
  end

  def self.cleanup!
    delete_all("expires_at <= NOW()")
  end
end