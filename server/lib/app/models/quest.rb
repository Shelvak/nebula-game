# This class has such attributes:
#
# - parent_id (Fixnum): ID of a quest that player must have completed before
# engaging this one.
# - rewards (Hash):
#   {
#     'metal' => Fixnum,
#     'energy' => Fixnum,
#     'zetium' => Fixnum,
#     'points' => Fixnum,
#     'xp' => Fixnum,
#     'units' => [
#       {'type' => "Trooper", 'level' => 2, 'count' => 2}
#     ],
#   }
# - help_url_id (String): ID of help article associated to this quest in
# knowledge base.
#
class Quest < ActiveRecord::Base
  belongs_to :parent, :class_name => "Quest"
  # FK :dependent => :delete_all
  has_many :children, :class_name => "Quest", :foreign_key => "parent_id"
  # FK :dependent => :delete_all
  has_many :quest_progresses
  # FK :dependent => :delete_all
  has_many :objectives

  custom_serialize :rewards,
    :serialize => lambda { |rewards| rewards.to_json },
    :unserialize => lambda { |json| Rewards.from_json(json) }

  # Return +Quest+ as +Hash+.
  def as_json(options=nil)
    {
      :id => id,
      :rewards => rewards.as_json(options),
      :help_url_id => help_url_id,
    }
  end

  # Returns nested hash of quests.
  #
  # Example:
  # [
  #   {
  #     :quest => Quest,
  #     :progress => QuestProgress,
  #     :objectives => [
  #       {
  #         :objective => Objective,
  #         :progress => nil (if completed) or ObjectiveProgress
  #       },
  #       ...
  #     ]
  #   },
  #   ...
  # ]
  #
  def self.hash_all_for_player_id(player_id)
    objective_progresses = ObjectiveProgress.where(:player_id => player_id
      ).all.hash_by { |item| item.objective_id }
    
    QuestProgress.where(:player_id => player_id).includes(
      :quest => :objectives).map do |quest_progress|
      {
        :quest => quest_progress.quest,
        :progress => quest_progress,
        :objectives => quest_progress.quest.objectives.map do |objective|
          {
            :objective => objective,
            :progress => objective_progresses[objective.id]
          }
        end
      }
    end
  end

  # Start child quests for given player.
  def self.start_child_quests(parent_id, player_id)
    Quest.where(:parent_id => parent_id).each do |quest|
      quest_progress = QuestProgress.new(:quest_id => quest.id,
        :player_id => player_id, :status => QuestProgress::STATUS_STARTED)
      quest_progress.save!
    end
  end

  # DSL
  def define(*args, &block); self.class.define(self, *args, &block); end

  def self.define(*args, &block)
    case args.first
    when Quest
      parent = args.shift
    when Fixnum
      parent = Quest.find(args.shift)
    else
      parent = nil
    end
    help_url_id = args.shift

    dsl = Quest::DSL.new(parent, help_url_id)
    dsl.instance_eval(&block)
    dsl.save!
  end
end