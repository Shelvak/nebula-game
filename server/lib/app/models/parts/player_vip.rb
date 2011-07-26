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
          raise CallbackManager::UnknownEvent.new(self, id, event)
        end
      end
    end

    module InstanceMethods
      # Is this player VIP?
      def vip?; vip_level > 0; end

      def vip_creds_per_tick
        vip_level == 0 ? 0 : CONFIG['creds.vip'][vip_level - 1][1]
      end
  
      # Number of creds without VIP creds.
      def pure_creds; creds - vip_creds; end
      # Setter for pure creds.
      def pure_creds=(value); self.creds = value + vip_creds; end

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
  
      # Returns conversion rate from VIP creds to regular creds. It is 
      # dependant from players #vip_level.
      #
      # Returned number is how much VIP creds 1 regular cred is worth.
      #
      def vip_conversion_rate
        raise GameLogicError.new("Non-vips do not have vip conversion rate!") \
          if vip_level == 0

        cost, per_day, duration = CONFIG['creds.vip'][vip_level - 1]
        (per_day * duration / 1.day / cost).floor + 0.5
      end

      # Convert given amount of VIP creds into regular creds using 
      # #vip_conversion_rate. End amount is floored.
      def vip_convert(amount)
        raise GameLogicError.new(
          "Cannot convert negative amount of creds (#{amount}!"
        ) unless amount > 0
        raise GameLogicError.new("Not enough VIP creds! Wanted: #{amount
          }, had #{vip_creds}.") unless vip_creds >= amount

        converted_creds = (amount / vip_conversion_rate).floor
        # Because self.creds have both vip and regular creds we must 
        # subtract vip creds amount too.
        self.creds += converted_creds - amount
        # or else before_save handler dies.
        self.vip_creds -= converted_creds

        self
      end
    end
  end
end
