# Class for defining and saving quests to database.
class QuestDefinition
  # Define quests in this block. They will get automatically saved after
  # your block is done.
  def self.define(&block)
    db_quest_ids = Set.new(Quest.connection.select_values(
      "SELECT id FROM `#{Quest.table_name}`").map(&:to_i))

    definition = new(db_quest_ids)
    definition.instance_eval(&block)
    definition.save!

    definition
  end

  def initialize(db_quest_ids)
    @db_quest_ids = db_quest_ids
    @defined_quest_ids = Set.new
    # Quests which got new children.
    @newborn_parent_ids = {}

    @dsls = []
  end

  # Save all defined quests and start available ones for players.
  def save!
    @dsls.each { |dsl| dsl.save! }
    @dsls.clear

    @quests_started_count, @quests_started_players = start_newborn_parents!

    true
  end
  
  def count_in_definition; @defined_quest_ids.size; end

  def count_in_db; @db_quest_ids.size; end

  attr_reader :quests_started_count, :quests_started_players

  def define(*args, &block)
    case args.first
    when QuestDefinition::WithParent
      parent_wrapper = args.shift
      parent_id = parent_wrapper.parent_id
    else
      parent_id = nil
    end
    quest_id = args.shift
    help_url_id = args.shift

    raise ArgumentError.new(
      "Trying to define quest with id #{quest_id.inspect
        } but it's already in definition!"
    ) if @defined_quest_ids.include?(quest_id)
    @defined_quest_ids.add quest_id

    # Don't save quests which are already in database.
    unless @db_quest_ids.include?(quest_id)
      # Add parent as having new children if it already exists in db.
      if parent_id.nil? || @db_quest_ids.include?(parent_id)
        @newborn_parent_ids[parent_id] ||= []
        @newborn_parent_ids[parent_id].push quest_id
      end

      dsl = Quest::DSL.new(parent_id, quest_id, help_url_id)
      dsl.instance_eval(&block)
      @dsls.push dsl
    end

    QuestDefinition::WithParent.new(self, quest_id)
  end

  private
  def start_newborn_parents!
    count = 0
    players = Set.new

    @newborn_parent_ids.each do |parent_id, quest_ids|
      if parent_id.nil?
        # All players must start this is parent id is nil.
        player_ids = Player.connection.select_values(
          "SELECT id FROM `#{Player.table_name}`"
        ).map(&:to_i)
      else
        # Only those players which have completed the parent quest must get
        # this quest.
        player_ids = QuestProgress.where(
          :quest_id => parent_id,
          :status => [
            QuestProgress::STATUS_COMPLETED,
            QuestProgress::STATUS_REWARD_TAKEN
          ]
        ).map(&:player_id)
      end

      player_ids.each do |player_id|
        players.add player_id

        quest_ids.each do |quest_id|
          quest_progress = QuestProgress.new(
            :quest_id => quest_id,
            :player_id => player_id,
            :status => QuestProgress::STATUS_STARTED
          )
          quest_progress.save!
          count += 1
        end
      end
    end

    [count, players.size]
  end
end

class QuestDefinition::WithParent
  attr_reader :parent_id

  def initialize(definition, parent_id)
    @definition = definition
    @parent_id = parent_id
  end

  def define(*args, &block)
    @definition.define(self, *args, &block)
  end
end
