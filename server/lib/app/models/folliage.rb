class Folliage < ActiveRecord::Base
  include FastFind
  def self.fast_find_columns
    {:x => :to_i, :y => :to_i, :variation => :to_i}
  end

  belongs_to :planet

  def as_json(options=nil)
    attributes.except('planet_id')
  end
end