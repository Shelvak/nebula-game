module Parts
  # Stuff that is related to VIP players.
  #
  # Attributes:
  # * #vip_free (Boolean) - is VIP bought with free creds? If so, when you
  # #vip_convert the creds, #free_creds should also be incremented.
  #
  module PlayerVip
    def self.included(receiver)
      receiver.send(:include, InstanceMethods)
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

        stats = CredStats.vip(self, vip_level, cost)
        self.vip_free = true if free_creds >= cost / 2
        self.creds -= cost
        self.vip_level = vip_level
        self.vip_until = duration.from_now

        vip_tick!
        CallbackManager.register(
          self, CallbackManager::EVENT_VIP_STOP, vip_until
        )
        stats.save!
        Objective::BecomeVip.progress(self)
      end

      # Call to refresh player creds.
      def vip_tick!
        raise GameLogicError.new("Not a VIP!") unless vip?

        self.vip_creds = vip_creds_per_tick

        duration = Cfg.player_vip_tick_duration
        # Only register next VIP creds until if it is not the last VIP day.
        if vip_creds_until.nil? || vip_creds_until + duration < vip_until
          self.vip_creds_until ||= Time.now
          self.vip_creds_until += duration

          CallbackManager.register(
            self, CallbackManager::EVENT_VIP_TICK, vip_creds_until
          )
        end

        save!
      end

      # Stop VIP membership.
      def vip_stop!
        raise GameLogicError.new("Not a VIP!") unless vip?
        
        self.vip_creds = 0
        self.vip_level = 0
        self.vip_until = nil
        self.vip_creds_until = nil
        self.vip_free = false

        save!
        CallbackManager.unregister(self, CallbackManager::EVENT_VIP_STOP)
        CallbackManager.unregister(self, CallbackManager::EVENT_VIP_TICK)
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
        if vip_free?
          self.free_creds += converted_creds
        else
          self.pure_creds += converted_creds
        end
        self.vip_creds -= amount

        self
      end
    end
  end
end
