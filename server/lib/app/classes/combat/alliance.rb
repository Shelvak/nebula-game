# Stores +Flank+s for alliance.
class Combat::Alliance < Hash
  def initialize(alliances_list, alliance_id)
    @alliances_list = alliances_list
    @alliance_id = alliance_id
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
    @alliances_list.delete(@alliance_id) if size == 0
  end
end