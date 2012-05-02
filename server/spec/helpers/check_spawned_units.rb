def check_spawned_units_by_random_definition(
  definition, location, player_id, counter, spot
)
  counts = Unit.in_location(location).
    where(:player_id => player_id).
    all.grouped_counts { |unit| [unit.type, unit.flank] }
  params = {'counter' => counter, 'spot' => spot}

  definition.each do
    |count_from, count_to, type, flank|

    count_from = CONFIG.safe_eval(count_from, params).to_i
    count_to = CONFIG.safe_eval(count_to, params).to_i

    (count_from..count_to).should include(counts[[type, flank]] || 0)
  end
end