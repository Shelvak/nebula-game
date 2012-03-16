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
  ACTION_INDEX = 'notifications|index'

  INDEX_OPTIONS = logged_in + only_push
  INDEX_SCOPE = scope.world
  def self.index_action(m)
    without_locking do
      base = Notification.where(:player_id => m.player.id)
      main = base.where("`starred`=? OR `read`=? OR event=?",
        true, false, Notification::EVENT_ALLIANCE_INVITATION).all
      extras = base.where(:starred => false, :read => true).
        limit(Cfg.notification_limit).all
      notifications = (main | extras).sort do |n1, n2|
        (n1.created_at <=> n2.created_at) * -1
      end

      respond m, :notifications => notifications.map(&:as_json)
    end
  end

  # Marks notification as read.
  #
  # Invocation: by client after reading a notification
  # Params:
  #   - ids (Fixnum[]): notification ids to be read.
  # Response: None
  #
  ACTION_READ = 'notifications|read'

  READ_OPTIONS = logged_in + required(:ids => Array)
  READ_SCOPE = scope.world
  def self.read_action(m)
    Notification.where(:player_id => m.player.id, :id => m.params['ids']).
      update_all(:read => true)
  end

  # Marks notification as starred.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): notification id
  # - mark (Boolean): should this notification be starred
  #
  # Response: None
  #
  ACTION_STAR = 'notifications|star'

  STAR_OPTIONS = logged_in + required(:id => Fixnum, :mark => Boolean)
  STAR_SCOPE = scope.world
  def self.star_action(m)
    notification = Notification.where(:player_id => m.player.id).
      find(m.params['id'])
    notification.starred = m.params['mark']
    notification.save!
  end
end