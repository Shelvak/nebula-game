class NotificationsController < GenericController
  # Lists most recent, unread & starred notifications.
  #
  # Invocation: pushed by server after galaxies|select
  # 
  # Params: None
  # 
  # Response:
  # - notifications (Hash[]): Notification#as_json array
  #
  def action_index
    only_push!
    
    base = Notification.where(:player_id => player.id)
    main = base.where("`starred`=? OR `read`=?", true, false).all
    extras = base.where(:read => true).limit(Cfg.notification_limit).all
    notifications = (main | extras).sort do |n1, n2|
      (n1.created_at <=> n2.created_at) * -1
    end
    
    respond :notifications => notifications.map(&:as_json)
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