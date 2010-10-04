# All models that are in locations (i.e. +Unit+ or +RouteHop+) should
# include this.
module Parts::InLocation
  def self.included(receiver)
    receiver.send(:scope, :in_zone,
      Proc.new { |zone| {:conditions => zone.zone_attrs}}
    )
    receiver.send(:scope, :in_location,
      Proc.new { |location_attrs| {:conditions => location_attrs} }
    )
  end
end
