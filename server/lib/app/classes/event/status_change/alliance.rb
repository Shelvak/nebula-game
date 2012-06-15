# This gets created when alliance accepts/throws out a player and 
# unit/planet statuses need to be changed in client.
class Event::StatusChange::Alliance < Event::StatusChange
  # Player gets accepted to alliance
  ACCEPT = :accept
  # Player gets thrown out of alliance
  THROW_OUT = :throw_out
  
  def initialize(alliance, player, action)
    statuses = {}
    
    status = case action
    when ACCEPT
      StatusResolver::ALLY
    when THROW_OUT
      StatusResolver::ENEMY
    else
      raise ArgumentError.new("Unknown action: #{action.inspect}!")
    end
    
    without_locking { alliance.players.all }.each do |alliance_player|
      unless alliance_player == player
        statuses[alliance_player.id] ||= []
        statuses[alliance_player.id].push([player.id, status])
        
        statuses[player.id] ||= []
        statuses[player.id].push([alliance_player.id, status])
      end
    end
    
    super(statuses)
  end
end