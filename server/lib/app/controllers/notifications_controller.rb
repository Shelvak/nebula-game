class NotificationsController < GenericController
  # Lists all notifications.
  #
  # Invocation: pushed by server after galaxies|select
  # Params: None
  # Response:
  #   - notifications: array of Notification objects
  #
  def action_index
    only_push!
    respond :notifications => Notification.find(:all,
      :conditions => {:player_id => player.id})
  end

  # Marks notification as read.
  #
  # Invocation: by client after reading a notification
  # Params:
  #   - ids (Fixnum[]): notification ids to be read.
  # Response: None
  #
  def action_read
    param_options(:required => %w{ids})
    Notification.update_all({:read => true},
      {:player_id => player.id, :id => params['ids']})
  end

  # Marks notification as starred.
  #
  # Invocation: by client after clicking star button
  # Params:
  #   - id: notification id
  #   - mark (bool): should this notification be starred
  # Response: None
  #
  def action_star
    param_options(:required => %w{id mark})
    notification = Notification.find(params['id'],
      :conditions => {:player_id => player.id})
    notification.starred = params['mark']
    notification.save!
  end
end