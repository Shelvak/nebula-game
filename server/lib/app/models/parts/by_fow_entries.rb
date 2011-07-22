module Parts::ByFowEntries
	module ClassMethods
    # Returns objects visible by _fow_entries_ in +Galaxy+.
    def by_fow_entries(fow_entries)
      where(FowGalaxyEntry.conditions(fow_entries)).all
    end
	end

	module InstanceMethods

	end

	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end
