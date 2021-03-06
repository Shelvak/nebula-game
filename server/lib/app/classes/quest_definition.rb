# Class for defining and saving quests to database.
class QuestDefinition
  # Define quests in this block. They will get automatically saved after
  # your block is done.
  def self.define(options={}, &block)
    db_quest_ids = Set.new(Quest.connection.select_values(
      "SELECT id FROM `#{Quest.table_name}`").map(&:to_i))

    definition = new(db_quest_ids, options)
    definition.instance_eval(&block)

    definition
  end

  def initialize(db_quest_ids, options={})
    @db_quest_ids = db_quest_ids
    @defined_quest_ids = Set.new
    # Quests which got new children.
    @newborn_parent_ids = {}

    @debug = options[:debug]

    @dsls = []
    @dsls_for_checking = []
  end

  # Save all defined quests and start available ones for players.
  def save!
    if @debug
      puts "Saving quest DSLs:"
      @dsls.each do |dsl|
        puts "  #{dsl.to_s}"
      end
    end

    ActiveRecord::Base.transaction do
      @dsls.each { |dsl| dsl.save! }
    end
    @dsls.clear

    @quests_started_count, @quests_started_players = start_newborn_parents!

    true
  end
  
  # #save! quests and return statistics string.
  def sync!
    save!

    "Quests in definition: #{count_in_definition}\n" +
      "Quests in database  : #{count_in_db}\n" +
      "Added to database   : #{count_in_definition - count_in_db}\n" +
      "#{QUESTS.quests_started_count} quests started for #{
      quests_started_players} players."
  end
  
  # Checks definition against actual database records.
  #
  # If any mismatches are found, returns errors in such format:
  # 
  # [
  #   [quest_id, [error_string_1, error_string_2, ...],
  #   ...
  # ]
  #
  def check
    errors = []
    
    @dsls_for_checking.each do |dsl|
      dsl_errors = dsl.check
      errors.push [dsl.id, dsl_errors] unless dsl_errors.blank?
    end
    
    errors
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
    main_quest_slides = args.shift

    #puts "define_quest(#{quest_id}, #{parent_id}, #{main_quest_slides.inspect
    #  }, false, #{block})"
    define_quest(quest_id, parent_id, main_quest_slides, false, block)
  end

  def achievement(quest_id, &block)
    define_quest(quest_id, nil, nil, true, block)
  end

  private
  def define_quest(quest_id, parent_id, main_quest_slides, achievement, block)
    raise ArgumentError.new("Quest cannot be without an ID! parent: #{
      parent_id.inspect}, main_quest_slides: #{main_quest_slides.inspect}") \
      if quest_id.nil?

    raise ArgumentError.new(
      "Trying to define quest with id #{quest_id.inspect
        } but it's already in definition!"
    ) if @defined_quest_ids.include?(quest_id)
    @defined_quest_ids.add quest_id

    dsl = Quest::Dsl.new(parent_id, quest_id, main_quest_slides, achievement)
    dsl.instance_eval(&block)
    @dsls_for_checking.push dsl
    
    # Don't save quests which are already in database.
    unless @db_quest_ids.include?(quest_id)
      # Add parent as having new children if it already exists in db.
      if parent_id.nil? || @db_quest_ids.include?(parent_id)
        @newborn_parent_ids[parent_id] ||= []
        @newborn_parent_ids[parent_id].push quest_id
      end
      
      @dsls.push dsl
    end

    QuestDefinition::WithParent.new(self, quest_id)
  end

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

  def define_points_chain(points_method, start_id, quest_count, start_points,
      multiplier, resources_multiplier=nil, creds_multiplier=nil)
    quest = self
    quest_count.times do |i|
      quest = quest.define(start_id + i) do
        points = (start_points * multiplier ** i).ceil
        send(points_method, points)
        #puts "! #{i}"
        reward_resources_for_points points, resources_multiplier
        reward_creds_for_points points, creds_multiplier
      end
    end

    quest
  end

  def define_eco_chain(start_id, quest_count, start_points, multiplier)
    define_points_chain(:have_economy_points, start_id, quest_count,
                        start_points, multiplier, 0.0075, 0.125)
  end

  def define_war_chain(start_id, quest_count, start_points, multiplier)
    define_points_chain(:have_war_points, start_id, quest_count,
                        start_points, multiplier, 0.015, 0.25)
  end
end