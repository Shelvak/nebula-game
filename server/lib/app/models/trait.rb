module Trait
	module ClassMethods
    def has_trait?(trait)
      self.include?(trait)
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
		receiver.send :include, InstanceMethods
  end
end