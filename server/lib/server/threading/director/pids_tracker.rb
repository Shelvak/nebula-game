class Threading::Director::PidsTracker
  def initialize
    @data = {}
  end

  def to_s
    @data.inspect
  end

  def empty?
    @data.size == 0
  end

  def register_pids(player_ids, name)
    player_ids.each do |player_id|
      register_pid(player_id, name)
    end
  end

  def register_pid(player_id, name)
    @data[player_id] ||= {}
    @data[player_id][name] ||= 0
    @data[player_id][name] += 1
  end

  def unregister_pids(player_ids, name)
    player_ids.each do |player_id|
      unregister_pid(player_id, name)
    end
  end

  def unregister_pid(player_id, name)
    remaining = @data[player_id][name] -= 1
    @data[player_id].delete name if remaining == 0
    @data.delete player_id if @data[player_id].size == 0
    true
  end

  def currently_working_on(player_ids)
    working = Set.new
    player_ids.each do |player_id|
      working += @data[player_id].keys if @data.has_key?(player_id)
    end
    working.to_a
  end
end
