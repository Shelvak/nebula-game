class PlayerOptions < ActiveRecord::Base
  set_primary_key :player_id
  belongs_to :player

  # Ignored player chat messages are not shown at all.
  CHAT_IGNORE_COMPLETE = "complete"
  # Ignored player chat messages are shown with text filtered out, like this:
  # <ignored_player> [you are ignoring this user]
  CHAT_IGNORE_FILTERED = "filtered"

  CHAT_IGNORE_TYPES = [CHAT_IGNORE_COMPLETE, CHAT_IGNORE_FILTERED]

  custom_serialize :data,
    :serialize => lambda { |data| JSON.generate(data.as_json) },
    :unserialize => lambda { |json| Data.new(JSON.parse(json)) }

  def as_json(options=nil)
    data.as_json(options)
  end

  def self.find(player_id)
    options = where(:player_id => player_id).first
    if options.nil?
      raise ActiveRecord::RecordNotFound.new(
        "Player with id #{player_id} does not exist!"
      ) unless Player.exists?(player_id)
      options = new.tap { |o| o.id = player_id; o.data = Data.new }
    end
    options
  end
end