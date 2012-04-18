# Ensures that calls go to each thread local logger.
class GameConfig::ThreadRouter < BasicObject
  def initialize(global_config)
    @global_config = global_config
  end

  def method_missing(*args, &block)
    config = ::Thread.current[:config] ||= ::GameConfig::ThreadLocal.new(
      @global_config
    )
    config.send(*args, &block)
  end
end