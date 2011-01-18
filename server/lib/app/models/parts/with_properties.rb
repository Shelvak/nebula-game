module Parts::WithProperties
  def self.included(klass)
    klass.send :include, InstanceMethods
    klass.extend ClassMethods
  end

  module InstanceMethods
    def property(key)
      self.class.property(key)
    end

    # Evaluate property.
    def evalproperty(key, default=nil, params=nil)
      params ||= {'level' => level}
      self.class.evalproperty(key, default, params)
    end

    def constructable?; self.class.constructable?; end
    def xp_modifier; self.class.xp_modifier; end
  end

  module ClassMethods
    def constructable?; property('constructable', true); end
    def xp_modifier; property('xp_modifier', 1); end

    def property(key, default=nil)
      value = CONFIG["#{config_name}.#{key}"]
      value.nil? ? default : value
    end

    # Evaluate property with parameters substituted.
    def evalproperty(key, default=nil, params={})
      return 0 if params['level'] == 0

      formula = property(key)

      if formula.nil?
        if default.nil?
          raise ArgumentError.new("Property #{key} not found for #{
            self} and default is nil!")
        else
          default
        end
      else
        CONFIG.safe_eval(formula, params)
      end
    rescue Exception => e
      raise e.class.new(
        "While evaling property #{key.inspect\
        } for #{self
        }\n(default: #{default.inspect}, params: #{params.inspect
        })\n" + e.message
      )
    end

    def config_name
      type, subtype = to_s.split("::").map { |item| item.underscore }
      raise GameError.new("You cannot use class #{to_s
        } directly! Instead use it's subclasses.") if subtype.nil?

      "#{type.pluralize}.#{subtype}"
    end
  end
end
