module Parts::NeedsTechnology
	def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
	end

	module ClassMethods
    def needs_technologies?; ! @needed_technologies.blank?; end
    def needed_technologies; @needed_technologies; end

    # Add a needed technology. _technology_ is technology class.
    def needs_technology(technology, options={})
      @needed_technologies[technology] = options
    end

    # Set technology validations and callbacks from config if needed.
    def inherited(subclass)
      super
      subclass.send :attr_writer, :skip_validate_technologies
      subclass.send :define_method, :skip_validate_technologies? do
        !! @skip_validate_technologies
      end
      subclass.instance_variable_set("@needed_technologies", {})

      technologies = {}

      CONFIG.each_matching(
        /^#{subclass.config_name}\.requirement\./
      ) do |key, value|
        parts = key.split(".")

        technology = parts[3].camelcase
        property = parts[4]

        technologies[technology] ||= {}
        technologies[technology][property] = value
      end

      unless technologies.blank?
        technologies.each do |technology, options|
          subclass.needs_technology(
            "Technology::#{technology}".constantize,
            options.symbolize_keys
          )
        end

        subclass.validate :validate_technologies,
          :unless => :skip_validate_technologies?, :on => :create
      end
    end
	end

	module InstanceMethods
    def validate_technologies
      self.class.needed_technologies.each do |klass, options|
        level = options[:level] || (options[:invert] ? 0 : 1)

        technology = klass.find(:first, :conditions => [
          "player_id=? AND level>=?",
          player_id, level
        ])

        raise_error = technology.nil?
        raise_error = ! raise_error if options[:invert]

        errors.add(:base,
          "Technology #{klass.to_s} is required (#{options.inspect})!"
        ) if raise_error
      end
    end
	end
end