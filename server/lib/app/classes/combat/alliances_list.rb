# Stores alliances for combat simulation.
class Combat::AlliancesList
  # Returns a +Hash+ of player_id => alliance_id mappings.
  attr_reader :player_id_to_alliance_id

  def initialize(nap_rules)
    @alliances = {}
    @player_hashes = {}
    @enemy_ids = {}
    # List of alliance ids to delete upon #commit_deletes
    @commited_enemy_ids = []
    @player_id_to_alliance_id = {}
    @nap_rules = nap_rules
  end

  # Resolve _player_ to +Hash+ with :id and :name keys.
  def self.player_as_json(player)
    if player == Combat::NPC
      {
        :id => nil,
        :name => nil
      }
    else
      {
        :id => player.id,
        :name => player.name
      }
    end
  end

  # Return +Hash+ representation of _self_.
  #
  # Example output:
  #   {
  #     # Alliance (id 10)
  #     10 => {
  #       :players => [
  #         {:id => 10, :name => "orc"},
  #         {:id => 11, :name => "undead"},
  #         {:id => nil, :name => nil},
  #       ],
  #       :flanks => {
  #         0 => [
  #           {
  #             # Unit as returned from Combat::Participant#as_json
  #           },
  #           ...
  #         ],
  #         2 => [...],
  #         ...
  #       }
  #     },
  #     ...
  #   }
  #
  def as_json(options=nil)
    hash = {}

    @alliances.each do |alliance_id, alliance|
      alliance_hash = {
        :players => @player_hashes[alliance_id],
        :flanks => {}
      }

      alliance.each do |flank_index, flank|
        alliance_hash[:flanks][flank_index] = flank.map do |unit|
          Combat::Participant.as_json(unit)
        end
      end

      hash[alliance_id] = alliance_hash
    end

    hash
  end

  # Return Array of player ids.
  def player_ids
    ids = []
    @alliances.each do |alliance_id, alliance|
      @player_hashes[alliance_id].each do |player_hash|
        ids.push player_hash[:id]
      end
    end

    ids
  end

  delegate :'[]', :'each', :size, :to => :@alliances

  # Add an alliance. Set it as enemy to others (if no nap exists).
  def []=(alliance_id, alliance)
    alliance_id = alliance_id.to_i
    @alliances[alliance_id] = alliance
    @player_hashes[alliance_id] ||= []
    @enemy_ids[alliance_id] ||= []

    (
      @alliances.keys - [alliance_id] - (@nap_rules[alliance_id].to_a || [])
    ).each do |enemy_alliance_id|
      @enemy_ids[alliance_id].push enemy_alliance_id
      @enemy_ids[enemy_alliance_id].push alliance_id
    end
  end

  # Remove alliance from list. Also remove it from enemy lists of other
  # alliances.
  #
  # This method deletes alliance as a threat from other player lists, but
  # doesn't actually delete enemy lists for given alliance. This behavior
  # enables us to pick targets for units who shoot simultaneously.
  #
  # After everybody from shooting group has shot, call #commit_deletes to
  # ensure that cleanup is done and all dead units are gone.
  #
  def delete(alliance_id)
    @alliances.delete(alliance_id)
    # Don't delete right now, wait for commit
    @commited_enemy_ids.push alliance_id

    # Remove this alliance as a threat from every player.
    @enemy_ids.each do |enemy_alliance_id, enemy_list|
      enemy_list.delete(alliance_id)
      @enemy_ids.delete(enemy_alliance_id) if enemy_list.blank?
    end
  end

  # Remove enemy lists for committed alliances. See #delete.
  def commit_deletes
    @commited_enemy_ids.each do |alliance_id|
      @enemy_ids.delete(alliance_id)
    end

    @commited_enemy_ids.clear
  end

  # Remove alliances without any units.
  def cleanup!
    @alliances.each do |alliance_id, alliance|
      delete(alliance_id) if alliance.blank?
    end
  end

  def player_alive?(player_id)
    alliance_alive?(@player_id_to_alliance_id[player_id])
  end

  # Is given alliance still alive?
  def alliance_alive?(alliance_id)
    not @alliances[alliance_id].nil?
  end

  def player_has_enemies?(player_id)
    has_enemies?(@player_id_to_alliance_id[player_id])
  end

  def has_enemies?(alliance_id)
    @enemy_ids[alliance_id].present?
  end

  # Are there any enemies left?
  def enemies_left?
    @enemy_ids.present?
  end

  # Registers +Player+ as belonging to _alliance_id_.
  def register_player(alliance_id, player)
    player_id = (player == Combat::NPC ? Combat::NPC : player.id)
    @player_id_to_alliance_id[player_id] = alliance_id
    @player_hashes[alliance_id].push self.class.player_as_json(player)
  end
  
  def alliance_id_for(player_id)
    @player_id_to_alliance_id[player_id]
  end

  def alliance_for(player_id)
    self[alliance_id_for(player_id)]
  end

  # Returns id of random enemy alliance. Returns nil if we're the
  # only ones left.
  def enemy_id_for(alliance_id)
    if @enemy_ids[alliance_id].blank?
      nil
    else
      @enemy_ids[alliance_id].random_element
    end
  end
end