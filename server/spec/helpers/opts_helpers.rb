class SpecOptionsHelper < Hash
  def initialize(params)
    params.each do |key, value|
      self[key] = value
    end
  end

  # Alias for #merge
  def +(hash)
    merge(hash)
  end

  # Set all values to _object_.
  def apply(object)
    each do |key, value|
      object.send("#{key}=", value)
    end

    object
  end

  # Alias for #apply
  def |(object)
    apply(object)
  end

  # Same as #| but for factory objects
  def factory(factory_object)
    each do |key, value|
      factory_object.send(key, value)
    end
  end
end

def opts_active
  SpecOptionsHelper.new(:state => Building::STATE_ACTIVE)
end

def opts_inactive
  SpecOptionsHelper.new(:state => Building::STATE_INACTIVE)
end

def opts_working
  SpecOptionsHelper.new(:state => Building::STATE_WORKING)
end

def opts_upgrading
  last_update = 1.second.ago
  SpecOptionsHelper.new(
    :last_update => last_update,
    :upgrade_ends_at => last_update + 20.minutes,
    :pause_remainder => nil
  )
end

def opts_just_upgraded
  opts_upgrading + { :upgrade_ends_at => 1.second.ago }
end

def opts_just_started
  opts_upgrading + { :last_update => 1.second.ago }
end

def opts_paused
  opts = opts_upgrading
  opts + {
    :last_update => nil,
    :upgrade_ends_at => nil,
    :pause_remainder => Time.now.drop_usec - opts[:upgrade_ends_at]
  }
end