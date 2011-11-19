# Class encapsulating change of player statuses that should be updated in
# client.
class Event::StatusChange
  # Hash of {notifiable_player_id => [[player_id, new_status], ...]} pairs.
  # where _notifiable_player_id_ is id of +Player+ for which change should
  # be sent.
  attr_reader :statuses 
  
  def initialize(statuses)
    @statuses = statuses
  end
  
  def eql?(other)
    other.is_a?(self.class) && other.statuses == statuses
  end
  
  def ==(other)
    eql?(other)
  end
end