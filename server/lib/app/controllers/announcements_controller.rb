class AnnouncementsController < GenericController
  class << self
    # Returns [ends_at, announcement]
    def get
      synchronized { [@ends_at, @announcement] }
    end

    # Sets and dispatches current announcement. 
    def set(ends_at, message)
      LOGGER.info("Setting new announcement #{message.inspect
        } which expires @ #{ends_at}.")

      Dispatcher.instance.push_to_logged_in(
        ACTION_NEW, 
        {'ends_at' => ends_at, 'message' => message}
      )
      
      synchronized do
        @ends_at = ends_at
        @announcement = message
      end
      
      seconds = ends_at - Time.now
      Thread.new do
        sleep seconds if seconds > 0
        synchronized do
          # Don't clear announcement if it's not our announcement anymore.
          if @ends_at == ends_at
            @ends_at = nil
            @announcement = nil
            LOGGER.info("Expiring announcement #{message.inspect}.")
          else
            LOGGER.info("Announcement #{message.inspect} was replaced by #{
              @announcement.inspect}, not expiring..")
          end
        end
      end
    end
    
    protected
    def synchronized(&block)
      @mutex ||= Mutex.new
      @mutex.synchronize(&block)
    end
  end
  
  ACTION_NEW = 'announcements|new'
  # Send announcement to client.
  # 
  # Invocation: by server
  # 
  # Parameters:
  # - message (String): announcement text
  # - ends_at (Time): time when this announcement should be stopped being
  # shown.
  # 
  # Response: Same as parameters.
  #
  def action_new
    only_push!
    param_options :required => {:message => String, :ends_at => Time}
    
    respond :message => params['message'], :ends_at => params['ends_at']
  end
end