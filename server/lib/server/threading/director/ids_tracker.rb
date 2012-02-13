class Threading::Director::IdsTracker
  def initialize
    @data = {}
  end

  def to_s
    @data.inspect
  end

  def empty?
    @data.size == 0
  end

  def register_ids(ids, name)
    ids.each do |id|
      register_id(id, name)
    end
  end

  def register_id(id, name)
    @data[id] ||= {}
    @data[id][name] ||= 0
    @data[id][name] += 1
  end

  def unregister_ids(ids, name)
    ids.each do |id|
      unregister_id(id, name)
    end
  end

  def unregister_id(id, name)
    remaining = @data[id][name] -= 1
    @data[id].delete name if remaining == 0
    @data.delete id if @data[id].size == 0
    true
  end

  def currently_working_on(ids)
    working = Set.new
    ids.each do |id|
      working += @data[id].keys if @data.has_key?(id)
    end
    working.to_a
  end
end
