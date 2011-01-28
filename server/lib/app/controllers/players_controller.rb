class PlayersController < GenericController
  ACTION_SHOW = 'players|show'
  ACTION_DISCONNECT = 'players|disconnect'
  # Shows all player ratings on current players galaxy.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response:
  # - ratings (Hash[]): Player#as_json array with :ratings
  #
  ACTION_RATINGS = 'players|ratings'
  # Edits your properties.
  #
  # Invocation: by client
  #
  # Parameters:
  # - first_time (Boolean): should the first time screen be shown next time
  # player logs in?
  #
  ACTION_EDIT = 'players|edit'

  def invoke(action)
    case action
    when ACTION_SHOW
      only_push!
      respond :player => player
    when ACTION_RATINGS
      players = Player.where(:galaxy_id => player.galaxy_id).
        includes(:alliance)
      ratings = players.map { |player| player.as_json(:mode => :ratings) }
      respond :ratings => ratings
    when ACTION_EDIT
      param_options :valid => %w{first_time}

      player = self.player
      player.first_time = params['first_time'] \
        unless params['first_time'].nil?

      player.save!
    end
  end
end