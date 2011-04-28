# Tracks which technologies has which mods.
class TechTracker
  include Singleton

  def initialize
    # Hash of {name => Set} pairs.
    @tracker = {}
  end

  def register(name, klass)
    @tracker[name] ||= Set.new
    @tracker[name].add klass
  end

  # Returns technology classes for mod with _name_.
  def get(name)
    @tracker[name] || Set.new
  end

  # Return technology classes for mods with _names_.
  def get_all(*names)
    set = Set.new
    names.each { |name| set.merge(get(name)) }
    set
  end

  # Return AREL query for technologies which have mods.
  def query(*names)
    Technology.where(
      :type => get_all(*names).map { |klass| klass.to_s.demodulize }
    )
  end

  # Return AREL query for active technologies for player which have mods.
  def query_active(player_id, *names)
    query(*names).where("player_id=? AND level > 0", player_id)
  end

  class << self
    def method_missing(method, *args); instance.send(method, *args); end
  end
end