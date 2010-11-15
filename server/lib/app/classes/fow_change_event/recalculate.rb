# Same as FowChangeEvent but uses _changes_ obtained from
# FowSsEntry#recalculate to determine what players need to
# be notified.
class FowChangeEvent::Recalculate < FowChangeEvent
  def initialize(changes)
    player_ids = Set.new
    changes.each do |fse|
      if fse.alliance_id
        fse.alliance.member_ids.each do |player_id|
          player_ids.add(player_id)
        end
      else
        player_ids.add(fse.player_id)
      end
    end
    @player_ids = player_ids.to_a
  end
end
