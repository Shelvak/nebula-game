class PlayerOptionsController < GenericController
  # Sends options for this player.
  #
  # Invocation: by server
  #
  # Parameters: None
  #
  # Response:
  # - options (Hash): PlayerOptions#as_json
  ACTION_SHOW = 'player_options|show'

  SHOW_OPTIONS = logged_in + only_push
  def self.show_scope(message); scope.player(message.player); end
  def self.show_action(m)
    respond m, :options => m.player.options.as_json
  end

  # Set options for this player
  #
  # Invocation: by client
  #
  # Parameters: see PlayerOptions::Data for parameter names
  #
  # Response: None
  ACTION_SET = 'player_options|set'

  SET_OPTIONS = logged_in
  def self.set_scope(m); scope.player(m.player); end
  def self.set_action(m)
    opts = m.player.options.data

    params.each do |property, value|
      begin
        opts.send("#{property}=", value)
      rescue NoMethodError, ArgumentError => e
        raise GameLogicError, e.message, e.backtrace
      end
    end

    m.player.options.save!
  end
end