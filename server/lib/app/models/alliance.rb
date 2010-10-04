class Alliance < ActiveRecord::Base
  # Foreign key
  belongs_to :galaxy

  # FK :dependent => :nullify
  has_many :players
  # FK :dependent => :delete_all
  has_many :fow_ss_entries
  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  
  has_many :naps, :finder_sql => "SELECT * FROM `#{Nap.table_name
    }` WHERE initiator_id=\#{id} OR acceptor_id=\#{id}",
    :dependent => :destroy

  # Returns +Array+ of +Player+ ids who are in _alliance_ids_.
  # _alliance_ids_ can be Array or Fixnum.
  def self.player_ids_for(alliance_ids)
    Player.connection.select_values(%Q{
      SELECT id FROM `#{Player.table_name}` WHERE #{
        Player.sanitize_sql_hash_for_conditions(
          :alliance_id => alliance_ids
        )
      }
    }).map(&:to_i)
  end

  # Returns +Player+ ids who are members of this +Alliance+.
  def member_ids
    self.class.player_ids_for([id])
  end

  # Accepts _player_ into +Alliance+.
  def accept(player)
    raise GameLogicError.new("Cannot switch alliances (currently in: #{
      player.alliance_id})") unless player.alliance_id.nil?

    player.alliance = self
    player.save!

    # Add solar systems visible to player to alliance visibility pool.
    # Order matters here, because galaxy entry dispatches event.
    FowSsEntry.assimilate_player(self, player, false)
    FowGalaxyEntry.assimilate_player(self, player)

    true
  end

  # Removes _player_ from +Alliance+.
  def throw_out(player)
    raise GameLogicError.new(
      "Player is not in this alliance! (currently in: #{
      player.alliance_id}") unless player.alliance_id == id

    player.alliance = nil
    player.save!

    # Remove players visibility pool from alliance pool.
    # Order matters here, because galaxy entry dispatches event.
    FowSsEntry.throw_out_player(self, player, false)
    FowGalaxyEntry.throw_out_player(self, player)

    true
  end
end