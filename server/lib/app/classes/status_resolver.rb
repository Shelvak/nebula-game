# Resolves status from player id for particular player.
class StatusResolver
  # Unknown player id
  NPC = -1
  # Player is you.
  YOU = 0
  # Player is in your alliance.
  ALLY = 1
  # Player belongs to napped alliance.
  NAP = 2
  # Player is your enemy.
  ENEMY = 3

  # Initialize status resolver for given _player_.
  def initialize(player)
    @player = player
  end

  attr_reader :player

  def friendly_ids
    load_data unless @data_loaded
    
    [@player.id] | @alliance_player_ids
  end

  # Return status constant for _player_id_.
  def status(player_id)
    load_data unless @data_loaded

    if @player.id == player_id
      YOU
    elsif @alliance_player_ids.include?(player_id)
      ALLY
    elsif @nap_player_ids.include?(player_id)
      NAP
    elsif player_id.nil?
      NPC
    else
      ENEMY
    end
  end

  # Filters _objects_ and returns Array consisting only those objects where
  # status was resolved to _status_. Uses _player_method_ to retrieve player
  # id.
  def filter(objects, statuses, player_method=:player_id)
    statuses = [statuses] unless statuses.is_a?(Array)

    objects.reject do |object|
      # Support for NPC players.
      player_id = object.nil? ? Combat::NPC : object.send(player_method)
      ! statuses.include?(status(player_id))
    end
  end

  # Returns mapped Array of {:object => object, :status => status} hashes
  # formed from _objects_ Array. Uses _player_method_ to retrieve player id.
  #
  def resolve_objects(objects, player_method=:player_id)
    objects.map do |object|
      {
        :object => object,
        :status => status(object.send(player_method))
      }
    end
  end

  private
  def load_data
    get_alliance
    get_naps
    @data_loaded = true
  end

  # Retrieve player ids that are in your alliance.
  def get_alliance
    if @player.alliance_id
      @alliance_player_ids = ActiveRecord::Base.connection.select_values(
        "SELECT id FROM `#{Player.table_name
          }` WHERE `alliance_id`=#{@player.alliance_id.to_i}"
      ).map(&:to_i)
    else
      @alliance_player_ids = []
    end
  end

  def get_naps
    if @player.alliance_id
      rules = Nap.get_rules([@player.alliance_id])
      unless rules[@player.alliance_id].blank?
        @nap_player_ids = Player.
          select('id').
          where(:alliance_id => rules[@player.alliance_id].map(&:to_i)).
          c_select_values.
          map(&:to_i)

        return @nap_player_ids
      end
    end

    # There were no naps.
    @nap_player_ids = []
  end
end