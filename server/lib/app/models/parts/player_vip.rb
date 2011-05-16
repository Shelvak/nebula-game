module Parts
  module PlayerVip
    def self.included(receiver)
      receiver.send(:before_save) do
        if vip? && creds_changed?
          old, new = creds_change
          if new < old
            self.vip_creds -= old - new
            self.vip_creds = 0 if vip_creds < 0
          end
        end
      end

      receiver.send(:include, InstanceMethods)
      receiver.extend(ClassMethods)
    end

    module ClassMethods
      def on_callback(id, event)
        case event
        when CallbackManager::EVENT_VIP_TICK
          find(id).vip_tick!
        when CallbackManager::EVENT_VIP_STOP
          find(id).vip_stop!
        else
          raise ArgumentError.new("Don't know how to handle callback #{
            CallbackManager::STRING_NAMES[event]} (#{event})!")
        end
      end
    end

    module InstanceMethods
      # Is this player VIP?
      def vip?; vip_level > 0; end

      def vip_creds_per_tick
        vip_level == 0 ? 0 : CONFIG['creds.vip'][vip_level - 1][1]
      end

      # Start VIP membership.
      def vip_start!(vip_level)
        raise GameLogicError.new("Already a VIP!") if vip?

        cost, creds_per_day, duration = CONFIG['creds.vip'][vip_level - 1]
        raise ArgumentError.new("Unknown vip level #{vip_level
          }, max vip level #{CONFIG['creds.vip'].size}!") if cost.nil?

        raise GameLogicError.new("Not enough creds for vip level #{vip_level
          }! Needed: #{cost}, had: #{creds}") if creds < cost

        self.creds -= cost
        self.vip_level = vip_level
        self.vip_until = duration.from_now

        self.class.transaction do
          save!
          vip_tick!
          CallbackManager.register(self, CallbackManager::EVENT_VIP_STOP,
            vip_until)
          CredStats.vip!(self, vip_level, cost)
          Objective::BecomeVip.progress(self)
        end
      end

      # Call to refresh player creds.
      def vip_tick!
        raise GameLogicError.new("Not a VIP!") unless vip?

        per_tick = vip_creds_per_tick
        self.creds = creds - vip_creds + per_tick
        self.vip_creds = per_tick
        self.vip_creds_until = CONFIG['creds.vip.tick.duration'].from_now

        self.class.transaction do
          save!
          CallbackManager.register(self, CallbackManager::EVENT_VIP_TICK,
            vip_creds_until)
        end
      end

      # Stop VIP membership.
      def vip_stop!
        raise GameLogicError.new("Not a VIP!") unless vip?
        
        self.creds -= vip_creds
        self.vip_creds = 0
        self.vip_level = 0
        self.vip_until = nil
        self.vip_creds_until = nil

        self.class.transaction do
          save!
          CallbackManager.unregister(self, CallbackManager::EVENT_VIP_STOP)
          CallbackManager.unregister(self, CallbackManager::EVENT_VIP_TICK)
        end
      end
    end
  end
end
