class Combat::NotificationHelpers
  # A friend (you or your alliance).
  CLASSIFICATION_FRIEND = 0
  # An enemy (other players or alliances that aren't NAPs).
  CLASSIFICATION_ENEMY = 1
  # NAPs. Alliances that have established NAP with you.
  CLASSIFICATION_NAP = 2

  # Given structure from Combat::AlliancesList#as_json return simplified
  # structure without flanks.
  #
  # Example output:
  #   {
  #     # Alliance (id 10)
  #     10 => {
  #       :name => "FooBar Heroes",
  #       :players => [
  #         {:id => 10, :name => "orc"},
  #         {:id => 11, :name => "undead"},
  #         {:id => nil, :name => nil},
  #       ],
  #     },
  #     ...
  #   }
  #
  def self.alliances(alliances_hash)
    output = {}

    alliances_hash.each do |alliance_id, alliance|
      output[alliance_id] = {
        :name => alliance_id > 0 ? Alliance.find(alliance_id).name : nil,
        :players => alliance[:players]
      }
    end

    output
  end

  # Classify alliances to Yours/Enemy/Nap. Returns a new +Hash+ with each
  # alliance having :class key set.
  #
  # _alliances_ is +Hash+ obtained from #alliances.
  # _player_id_ is ID of +Player+ for which the classification is done.
  # _player_alliance_id_ is ID of +Player+ alliance.
  # _nap_rules_ is +Hash+ as gotten from Nap#get_rules.
  #
  #
  # Example output:
  #   {
  #     # Alliance (id 10)
  #     10 => {
  #       :name => "FooBar Heroes",
  #       :classification => CLASSIFICATION_FRIEND (0)
  #         || CLASSIFICATION_ENEMY (1)
  #         || CLASSIFICATION_NAP (2),
  #       :players => [
  #         {:id => 10, :name => "orc"},
  #         {:id => 11, :name => "undead"},
  #         {:id => nil, :name => nil}
  #       ],
  #     },
  #     ...
  #   }
  #
  def self.classify_alliances(alliances, player_id,
      player_alliance_id, nap_rules)
    output = {}

    alliances.each do |alliance_id, alliance|
      alliance_class = CLASSIFICATION_ENEMY

      if alliance[:players].find { |player| player[:id] == player_id }
        alliance_class = CLASSIFICATION_FRIEND
      elsif (nap_rules[player_alliance_id] || []).include?(alliance_id)
        alliance_class = CLASSIFICATION_NAP
      end

      output[alliance_id] = alliance.dup
      output[alliance_id][:classification] = alliance_class
    end

    output
  end

  # Returns +Hash+ of player statistics.
  #
  # _stats_ is statistics +Hash+ as returned from Combat#simulate_round.
  # _player_id_ is ID of +Player+.
  # _alliance_id_ is ID of +Alliance+ that +Player+ is in.
  #
  # Returns:
  # {
  #    :damage_dealt_player => +Fixnum+,
  #    :damage_dealt_alliance => +Fixnum+,
  #    :damage_taken_player => +Fixnum+,
  #    :damage_taken_alliance => +Fixnum+,
  #    :xp_earned => +Fixnum+,
  #    :points_earned => +Fixnum+,
  # }
  #
  def self.statistics_for_player(stats, player_id, alliance_id)
    {
      :damage_dealt_player => stats[:damage_dealt_player][player_id],
      :damage_dealt_alliance => stats[:damage_dealt_alliance][alliance_id],
      :damage_taken_player => stats[:damage_taken_player][player_id],
      :damage_taken_alliance => stats[:damage_taken_alliance][alliance_id],
      :xp_earned => stats[:xp_earned][player_id],
      :points_earned => stats[:points_earned][player_id]
    }
  end

  # Groups _units_ by _player_id_.
  #
  # Returns:
  # {
  #   player_id => [unit1, unit2, ...],
  #   ...
  # }
  #
  def self.group_participants_by_player_id(participants)
    participants.group_to_hash { |participant| participant.player_id }
  end

  # Group units into structure. Takes units as grouped by
  # #group_participants_by_player_id.
  #
  # Example output:
  # {
  #   player_id => {
  #     :alive => {
  #       "Unit::Trooper" => 10,
  #       "Unit::Shocker" => 5,
  #       ...
  #     },
  #     :dead => {
  #       "Unit::Trooper" => 4,
  #       "Unit::Shocker" => 2,
  #       ...
  #     }
  #   },
  #   ...
  # }
  #
  def self.report_participant_counts(participants_grouped_by_player_id)
    participant_counts = {}
    get_unit_type = lambda do |unit|
      unit.class.to_s
    end

    participants_grouped_by_player_id.each do |player_id, participants|
      alive, dead = participants.partition { |unit| unit.alive? }
      participant_counts[player_id] = {
        :alive => alive.grouped_counts(&get_unit_type),
        :dead => dead.grouped_counts(&get_unit_type),
      }
    end

    participant_counts
  end

  # Group units  into Hash with four bigger groups.
  #
  # _your_id_ - +Player+ ID of player representet as You.
  # _unit_counts_ - #report_participant_counts.
  # _player_id_to_alliance_id_ - AlliancesList#player_id_to_alliance_id
  # _nap_rules_ - Nap#get_rules
  #
  # :yours - your units, same as grouped_units[your_id]
  # :alliance - units in your alliance, except your units
  # :nap - units that are naps to you
  # :enemy - all other units
  #
  # Example output:
  #   {
  #     :yours => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :alliance => {
  #       :alive => {"Building::Vulcan" => 1, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :nap => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     },
  #     :enemy => {
  #       :alive => {"Unit::Trooper" => 10, "Unit::Shocker" => 5},
  #       :dead => {"Unit::Trooper" => 1, "Unit::Shocker" => 2}
  #     }
  #   }
  #
  def self.group_to_yane(your_id, unit_counts, player_id_to_alliance_id,
      nap_rules)

    yane = {
      :yours => unit_counts[your_id],
      :alliance => {:alive => {}, :dead => {}},
      :nap => {:alive => {}, :dead => {}},
      :enemy => {:alive => {}, :dead => {}}
    }

    your_alliance = player_id_to_alliance_id[your_id]

    unit_counts.each do |player_id, units|
      # We already covered this
      unless your_id == player_id
        side = nil

        # If the guy is in same alliance
        if your_alliance == player_id_to_alliance_id[player_id]
          side = :alliance
        # Or if he is in alliance that is napped with your
        elsif (nap_rules[your_alliance] || []).include?(
              player_id_to_alliance_id[player_id]
            )
          side = :nap
        # Otherwise he is a baddy!
        else
          side = :enemy
        end

        [:alive, :dead].each do |unit_status|
          # Merge all values to one big pool
          yane[side][unit_status].merge_values!(
            units[unit_status]
          ) do |a, b|
            a + b
          end
        end
      end
    end

    yane
  end

  # Filters units leaving only those that can level up.
  #
  # Returns Array of [unit, number_of_levels_it_can_go_up].
  #
  def self.filter_leveled_up(units)
    units.map do |unit|
      can_level_up_by = unit.can_upgrade_by
      if can_level_up_by != 0
        [unit, can_level_up_by]
      else
        nil
      end
    end.compact
  end

  # Filters units leaving only those that can level up.
  #
  # Example output:
  # [
  #   {:type => "Unit::Trooper", :hp => 10, :level => 3,
  #     :stance => Combat::STANCE_*},
  #   ...
  # ]
  #
  def self.leveled_up_units(units)
    filter_leveled_up(units).map do |unit, can_upgrade_by|
      {
        :type => unit.class.to_s,
        :hp => unit.hp,
        :level => unit.level + can_upgrade_by,
        :stance => unit.stance
      }
    end
  end
end