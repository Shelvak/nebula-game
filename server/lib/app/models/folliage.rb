class Folliage < ActiveRecord::Base
  default_scope lock(true)

  include FastFind
  def self.fast_find_columns
    {:x => :to_i, :y => :to_i, :kind => :to_i}
  end

  belongs_to :planet, :class_name => "SsObject::Planet"

  def as_json(options=nil)
    attributes.except('planet_id')
  end
end