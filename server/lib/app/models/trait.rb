module Trait
	module ClassMethods
    def has_trait?(trait)
      self.include?(trait)
    end

    # Return Array of demodulized Building classes that has trait.
    def types_with_trait(trait)
      trait.included_in_classes.map { |klass| klass.to_s.demodulize }
    end
	end

  module ChildClassMethods

  end
  
  module InstanceMethods
    def has_trait?(trait)
      self.class.has_trait?(trait)
    end
  end

  module ChildInstanceMethods

  end

  def self.child_included(child, receiver)
		receiver.extend         ChildClassMethods
		receiver.extend         child::ClassMethods
		receiver.send :include, ChildInstanceMethods
		receiver.send :include, child::InstanceMethods
  end

  def self.included(receiver)
		receiver.extend         ClassMethods
    receiver.scope :with_trait, Proc.new { |trait|
      {:conditions => [
        "`#{Building.table_name}`.type IN (?)",
        Building.types_with_trait(trait)
      ]}
    }
		receiver.send :include, InstanceMethods
  end
end