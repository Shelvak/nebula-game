class RSpecOptionsHelper < Hash
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
  RSpecOptionsHelper.new(:state => Building::STATE_ACTIVE)
end

def opts_inactive
  RSpecOptionsHelper.new(:state => Building::STATE_INACTIVE)
end

def opts_working
  RSpecOptionsHelper.new(:state => Building::STATE_WORKING)
end

def opts_upgrading
  RSpecOptionsHelper.new(
    :upgrade_ends_at => 20.minutes.from_now,
    :pause_remainder => nil
  )
end

def opts_just_upgraded
  opts_upgrading + { :upgrade_ends_at => 1.second.ago }
end

def opts_just_started
  opts_upgrading
end

def opts_paused
  opts = opts_upgrading
  opts + {
    :upgrade_ends_at => nil,
    :pause_remainder => opts[:upgrade_ends_at] - Time.now.drop_usec
  }
end

def opts_built
  RSpecOptionsHelper.new(:level => 1)
end

def opts_shielded(player_id=nil)
  player_id ||= Factory.create(:player).id
  RSpecOptionsHelper.new(:shield_ends_at => 10.hours.from_now,
    :shield_owner_id => player_id)
end