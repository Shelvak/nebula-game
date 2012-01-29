class PlayerOptionsController < GenericController
  ACTION_SHOW = 'player_options|show'
  # Sends options for this player.
  #
  # Invocation: by server
  #
  # Parameters: None
  #
  # Response:
  # - options (Hash): PlayerOptions#as_json
  def action_show
    only_push!

    respond :options => player.options.as_json
  end

  # Set options for this player
  #
  # Invocation: by client
  #
  # Parameters: see PlayerOptions::Data for parameter names
  #
  # Response: None
  def action_set
    opts = player.options.data

    params.each do |property, value|
      begin
        opts.send("#{property}=", value)
      rescue NoMethodError, ArgumentError => e
        raise GameLogicError.new(e.message)
      end
    end

    player.options.save!
  end
end