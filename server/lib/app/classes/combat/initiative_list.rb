# Groups units by initiative and ensures fair iteration over all units.
class Combat::InitiativeList
  def initialize
    # {
    #   initiative => {
    #     alliance_id => {:ground => [], :space => []},
    #     ...
    #   },
    #   ...
    # }
    #
    @groups = {}
    @max_units = 0
  end

  # Add units from all alliance members to initiative list.
  def add_units(alliances_list)
    alliances_list.each do |alliance_id, alliance|
      alliance.each do |flank_index, flank|
        flank.each do |unit|
          add(alliance_id, unit)
        end
      end
    end
  end

  UNIT_TYPES = [:ground, :space]

  # Yield units in groups of CONFIG['combat.parallel.count'].
  #
  # Units are yielded by ordered initiative. However units with same
  # initiative are yielded in random orders. Dead units are not yielded.
  def each
    # We're going to yield units by groups in _yield_at_ units.
    yield_at = CONFIG.evalproperty('combat.parallel.count',
      'count' => @max_units)

    # Iterate by initiatives starting from biggest one
    @groups.keys.sort.reverse_each do |initiative|
      alliance_units = @groups[initiative]

      # This is needed because not all alliances have same number of units.
      # However, all units must be yielded, so we store maximum number of
      # units any alliance has.
      max_units = 0
      
      # Store iteration orders to ensure random order of units.
      iteration_orders = {}

      alliance_units.each do |alliance_id, types|
        # Shuffle the iteration order index list to ensure random 
        # order of units.
        iteration_orders[alliance_id] = {}
        UNIT_TYPES.each do |type|
          iteration_orders[alliance_id][type] = (
            0...types[type].size
          ).to_a.shuffle
        end

        # Store max_units
        max_units = [max_units, types[:ground].size, types[:space].size].max
      end
      
      units_added = 0
      shooting_units = []
      (0...max_units).each do |unit_index|
        # Add a unit from each alliance.
        alliance_units.each do |alliance_id, types|
          UNIT_TYPES.each do |type|
            # Take unit index.
            unit_index = iteration_orders[alliance_id][type].shift

            # unit_index may be nil if this alliance is out of units.
            # What a shame. But if we have a unit index...
            while unit_index
              # Lets take it!
              unit = types[type][unit_index]

              # This unit might be dead. In that unfortunate case, just take
              # next one.
              if unit.dead?
                unit_index = iteration_orders[alliance_id][type].shift
              # Otherwise - this unit will shoot.
              else
                shooting_units.push [alliance_id, unit]
                # Stop iterating via units in this alliance.
                unit_index = nil
              end
            end
          end
        end
        
        # Hm. No units were added. We're out of units I think.
        if shooting_units.blank?
          # Let's skip to next initiative
          next
        else
          # We have added a unit from every alliance with every type.
          # Or at least we think so.
          units_added += 1
          
          # If we have our group - let's yield it
          if units_added == yield_at
            yield initiative, shooting_units

            # Reset the storage and counters.
            shooting_units.clear
            units_added = 0
          end
        end        
      end

      # Yield last batch of units that didn't make full group.
      yield initiative, shooting_units unless shooting_units.blank?
    end
  end

  private
  def add(alliance_id, unit)
    initiative = unit.property('initiative')
    raise ArgumentError.new(
      "Unit initiative expected to be Fixnum, but was #{initiative.inspect
        } for #{unit.inspect}!"
    ) unless initiative.is_a?(Fixnum)

    @groups[initiative] ||= {}
    @groups[initiative][alliance_id] ||= {:ground => [], :space => []}
    @groups[initiative][alliance_id][unit.kind].push unit

    @max_units += 1
  end
end
