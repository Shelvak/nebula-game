# Ensures that calls go to each thread local logger.
class Logging::ThreadRouter
  include Singleton

  def method_missing(*args, &block)
    logger = Thread.current[:logger] ||= Logging::Logger.new
    logger.send(*args, &block)
  end
end