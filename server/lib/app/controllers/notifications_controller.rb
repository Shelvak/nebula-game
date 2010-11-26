class NotificationsController < GenericController
  # Lists all notifications.
  #
  # Invocation: pushed by server after galaxies|select
  # Params: None
  # Response:
  #   - notifications: array of Notification objects
  #
  ACTION_INDEX = 'notifications|index'

  # Marks notification as read.
  #
  # Invocation: by client after reading a notification
  # Params:
  #   - ids (Fixnum[]): notification ids to be read.
  # Response: None
  #
  ACTION_READ = 'notifications|read'

  # Marks notification as starred.
  #
  # Invocation: by client after clicking star button
  # Params:
  #   - id: notification id
  #   - mark (bool): should this notification be starred
  # Response: None
  #
  ACTION_STAR = 'notifications|star'

  def invoke(action)
    case action
    when ACTION_INDEX
      only_push!
      respond :notifications => Notification.find(:all,
        :conditions => {:player_id => player.id})
    when ACTION_READ
      param_options(:required => %w{ids})
      Notification.update_all({:read => true},
        {:player_id => player.id, :id => params['ids']})

      true
    when ACTION_STAR
      param_options(:required => %w{id mark})
      notification = Notification.find(params['id'],
        :conditions => {:player_id => player.id})
      notification.starred = params['mark']
      notification.save!

      true

    end
  end
end