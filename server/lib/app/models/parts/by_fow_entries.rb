module Parts::ByFowEntries
  DEFAULT_PREFIX="location_"

	module ClassMethods
    # Returns objects visible by _fow_entries_ in +Galaxy+.
    def by_fow_entries(fow_entries, prefix=nil)
      prefix ||= Parts::ByFowEntries::DEFAULT_PREFIX
      where(FowGalaxyEntry.conditions(fow_entries, prefix))
    end
	end

	module InstanceMethods

	end

	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end
