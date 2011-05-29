# Class for claiming daily bonus rewards.
class DailyBonus
  class << self
    def get_bonus(player_id, points)
      type, *args = get_entry(player_id, points)
      rewards = Rewards.new
      
      case type
      when 'unit'
        class_name, level = args
        rewards.add_unit("Unit::#{class_name}".constantize, :level => level)
      when 'creds'
        rewards.add_creds args[0]
      when 'metal'
        rewards.add_metal args[0]
      when 'energy'
        rewards.add_energy args[0]
      when 'zetium'
        rewards.add_zetium args[0]
      end
      
      rewards
    end
    
    protected
    def get_entry(player_id, points)
      now = Time.now
      hash = player_id * 7 + now.year * 7 + now.month * 7 + now.day * 7
      name = get_range(points)
      entries = CONFIG["daily_bonus.range.#{name}"]
      entry = entries[hash % entries.size]
      raise ArgumentError.new("#{entry.inspect} is not an entry") \
        unless entry.is_a?(Array)
      entry
    end
    
    # Returns range name from player _points_.
    def get_range(points)
      CONFIG['daily_bonus.ranges'].each do |name, start, ending|
        return name if points >= start && (ending.nil? || points < ending)
      end
      
      raise ArgumentError.new("Cannot resolve range for #{points} points!")
    end
  end
end