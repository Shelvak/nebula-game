RSpec::Matchers.define :conform_to_tile_map do |map_set|
  match do |planet|
    @errors = []

    tiles.each do |kind, coords|
      if kind == Tile::VOID
        rows = Tile.
          select("x, y").
          where(:planet_id => planet.id).
          where(coords.map { |x, y| "(x=#{x} AND y=#{y})" }.join(" OR ")).
          c_select_all

        @errors << "There should not be any tiles at #{
          rows.map { |r| "#{r['x']},#{r['y']}"}.join(', ')
        }" if rows.size > 0
      else
        actual_coords = Tile.
          select("x, y").
          where(:planet_id => planet.id, :kind => kind).
          c_select_all.map { |row| [row['x'], row['y']] }

        extra_tiles = actual_coords - coords
        missing_tiles = coords - actual_coords

        @errors << "Extra tiles of #{Tile::MAPPING[kind]} @ #{
          extra_tiles.map { |x, y| "#{x},#{y}"}.join(', ')
        }" if extra_tiles.size > 0
        @errors << "Missing tiles of #{Tile::MAPPING[kind]} @ #{
          missing_tiles.map { |x, y| "#{x},#{y}"}.join(', ')
        }" if missing_tiles.size > 0
      end
    end

    @errors.size == 0
  end

  failure_message_for_should do |planet|
    "#{planet} should have had no errors but it did:\n\n" +
      @errors.map { |e| " * #{e}" }.join("\n")
  end

  failure_message_for_should_not do |planet|
    "#{planet} should have had some errors but it did not."
  end
end