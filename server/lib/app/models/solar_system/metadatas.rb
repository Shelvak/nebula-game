# TODO: spec
class SolarSystem::Metadatas
  def initialize(solar_system_ids)
    solar_system_ids = Array(solar_system_ids)

    @sso_metas = without_locking do
      SsObject.
        select("`solar_system_id`, `player_id`").
        where(solar_system_id: solar_system_ids).
        where("`player_id` IS NOT NULL").
        c_select_all
    end.each_with_object({}) do |row, hash|
      hash[row['solar_system_id']] ||= Set.new
      hash[row['solar_system_id']].add row['player_id']
    end

    @unit_metas = without_locking do
      Unit.
        select("`location_solar_system_id`, `player_id`").
        where(location_solar_system_id: solar_system_ids).
        where("`player_id` IS NOT NULL").
        c_select_all
    end.each_with_object({}) do |row, hash|
      hash[row['location_solar_system_id']] ||= Set.new
      hash[row['location_solar_system_id']].add row['player_id']
    end
  end

  def player_planets?(solar_system_id, player_id)
    @sso_metas[solar_system_id].try(:include?, player_id)
  end

  def player_ships?(solar_system_id, player_id)
    @unit_metas[solar_system_id].try(:include?, player_id)
  end

  def enemy_planets?(solar_system_id, friendly_ids)
    ! Set.new(friendly_ids).superset?(@sso_metas[solar_system_id] || Set.new)
  end

  def enemy_ships?(solar_system_id, friendly_ids)
    check_ss_id!(solar_system_id)
    ! Set.new(friendly_ids).superset?(@unit_metas[solar_system_id] || Set.new)
  end

  def alliance_planets?(solar_system_id, alliance_ids)
    check_ss_id!(solar_system_id)
    alliance_ids.any? { |id| @sso_metas[solar_system_id].try(:include?, id) }
  end

  def alliance_ships?(solar_system_id, alliance_ids)
    check_ss_id!(solar_system_id)
    alliance_ids.any? { |id| @unit_metas[solar_system_id].try(:include?, id) }
  end
end