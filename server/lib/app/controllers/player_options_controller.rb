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
    param_options :required => PlayerOptions::Data.properties

    opts = player.options.data

    PlayerOptions::Data.properties.each do |property|
      begin
        opts.send("#{property}=", params[property.to_s])
      rescue ArgumentError => e
        raise GameLogicError.new(e.message)
      end
    end

    player.options.save!
  end
end