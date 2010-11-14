# Stores +Flank+s for alliance.
class Combat::Alliance < Hash
  # Alliance ID
  attr_reader :id

  def initialize(alliances_list, alliance_id)
    @alliances_list = alliances_list
    @id = alliance_id
  end

  def add_unit(unit)
    self[unit.flank] ||= Combat::Flank.new(self, unit.flank)
    self[unit.flank].push unit
  end

  def []=(alliance_id, flank)
    super(alliance_id.to_i, flank)
  end
  
  def each
    keys.sort.each do |flank_index|
      yield flank_index, self[flank_index]
    end
  end

  # Returns flank index for new flank.
  def next_flank_index
    (keys.max || -1) + 1
  end

  # Delete given _flank_. Also delete self from +AlliancesList+ if we don't
  # have any flanks.
  def delete(flank)
    super(flank)
    @alliances_list.delete(@id) if size == 0
  end
end