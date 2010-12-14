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

  def invoke(action)
    case action
    when ACTION_SHOW
      only_push!
      respond :player => player
    when ACTION_RATINGS
      ratings = Player.where(:galaxy_id => player.galaxy_id).map do |player|
        player.as_json(:mode => :ratings)
      end
      respond :ratings => ratings
    end
  end
end