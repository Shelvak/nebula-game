module Combat::Transportation
  def has_stored_units?(transporter)
    ! @stored_units[transporter.id].blank?
  end

  def collect_units(transporter)
    # Always add things from flank which is in front.
    flank = @stored_units[transporter.id][0]

    units = []
    flank.each do |unit|
      volume = unit.volume
      if @transporter_buckets[transporter.id] >= volume
        units.push unit
        @transporter_buckets[transporter.id] -= volume
      end
    end

    # Remove selected units from flank
    units.each { |unit| flank.delete(unit) }

    # Remove flanks upon depletion.
    @stored_units[transporter.id].shift if flank.blank?

    units
  end

  # Teleports units from _transporter_ into _location_.
  #
  # Units are unloaded using bucket algorithm. Each tick bucket is filled
  # by some "unloading power" (UP). Then transporter tries to unload units
  # which are ordered by volume (descending) unloading one at a time.
  #
  # It we don't have enough UP and there are no units that we can unload in
  # this tick the remainder is kept for next tick.
  #
  def unload_from(transporter)
    @transporter_buckets[transporter.id] ||= 0
    @transporter_buckets[transporter.id] += transporter.unload_per_tick

    # Retrieve maximum number of units with current unloading capability.
    collect_units(transporter).each do |unit|
      volume = unit.volume
      transporter.stored -= volume

      unit.location = @location
      alliance_id = @alliances_list.alliance_id_for(unit.player_id)
      @alliances_list[alliance_id].add_unit(unit)
      # Add unit to waiting list, it be added to initiative list in next
      # turn.
      @teleported_units.push [alliance_id, unit]

      debug "Teleportation", :unit => unit, :volume => volume
      yield unit
    end
  end
end
