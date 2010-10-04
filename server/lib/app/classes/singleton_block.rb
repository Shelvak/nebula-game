# Class for running one block of same name at a time
class SingletonBlock
  @@running = {}
  @@lock = Mutex.new

  class << self
    def run(name, operation=nil, callback=nil, options={}, &block)
      unless running?(name)
        operation ||= block

        options.reverse_merge!(:defer => true)
        if options[:defer]
          EventMachine.defer(
            proc do
              SingletonBlock.started(name)
              LOGGER.block(name) { operation.call }
            end,
            proc do
              LOGGER.block("#{name} CALLBACK") { callback.call } if callback
              SingletonBlock.finished(name)
              ActiveRecord::Base.clear_reloadable_connections!
            end
          )
        else
          SingletonBlock.started(name)
          LOGGER.block(name) { operation.call }
          LOGGER.block("#{name} CALLBACK") { callback.call } if callback
          SingletonBlock.finished(name)
        end
      end
    end

    def running?(name)
      @@lock.synchronize do
        ! @@running[name].nil?
      end
    end

    def started(name)
      @@lock.synchronize do
        @@running[name] = true
      end
    end

    def finished(name)
      @@lock.synchronize do
        @@running.delete(name)
      end
    end
  end
end