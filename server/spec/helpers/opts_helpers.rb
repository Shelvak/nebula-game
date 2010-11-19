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
      if value.is_a?(Proc)
        object.send("#{key}=", value.call(object))
      else
        object.send("#{key}=", value)
      end
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
      if value.is_a?(Proc)
        factory_object.send(key, &value)
      else
        factory_object.send(key, value)
      end
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

def opts_built
  SpecOptionsHelper.new(
    :level => 1,
    :hp => lambda do |r|
      # Evil hack, because r.hit_points(1) do not pass arguments to method.
      # WTF?!
      r.instance_variable_get("@instance").class.hit_points(1)
    end
  )
end