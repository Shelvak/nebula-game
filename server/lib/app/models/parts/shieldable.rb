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
      # Look to #has_shield? for conditions.
      scope :shielded, where("shield_owner_id IS NOT NULL AND " +
          "shield_ends_at IS NOT NULL AND shield_ends_at > NOW()")
    end
  end

  # Does this object have shield?
  #
  # Objects have shields if the owner is set and shield expiration date is
  # in the future.
  def has_shield?
    ! shield_owner_id.nil? && ! shield_ends_at.nil? &&
      shield_ends_at > Time.now
  end

  def as_json(options=nil)
    hash = defined?(super) ? super(options) : {}
    if has_shield?
      hash["shield_ends_at"] = shield_ends_at.as_json
      hash["shield_owner_id"] = shield_owner_id
    end
    hash
  end
end
