def check_spawned_units_by_random_definition(definition, galaxy_id, location,
    player_id)
  counts = Unit.in_location(location).
    where(:galaxy_id => galaxy_id, :player_id => player_id).
    all.grouped_counts { |unit| [unit.type, unit.flank] }

  definition.each do
    |count_from, count_to, type, flank|

    (count_from..count_to).should include(counts[[type, flank]] || 0)
  end
end