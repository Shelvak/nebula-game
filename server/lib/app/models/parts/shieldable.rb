# This module is included by classes that have ability to be shielded.
#
# They have following attributes:
# - shield_owner_id (Fixnum): ID of +Player+ which owns the shield and can
# call it off.
# - shield_ends_at (Time): shield expiration date.
#
# They also have #belongs_to association as #shield_owner to +Player+.
#
module Parts::Shieldable
  def self.included(receiver)
    super(receiver)
    receiver.instance_eval do
      belongs_to :shield_owner, :foreign_key => :shield_owner_id,
        :class_name => "Player"
      scope :shielded, where("shield_owner_id IS NOT NULL")
    end
  end

  # Does this object have shield?
  def has_shield?
    ! shield_owner_id.nil?
  end

  def as_json(options=nil)
    hash = defined?(super) ? super(options) : {}
    hash["shield_owner_id"] = shield_owner_id if has_shield?
    hash
  end
end
