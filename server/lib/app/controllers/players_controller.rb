class PlayersController < GenericController
  ACTION_SHOW = 'players|show'
  ACTION_DISCONNECT = 'players|disconnect'

  def invoke(action)
    case action
    when ACTION_SHOW
      only_push!
      respond :player => player
    end
  end
end