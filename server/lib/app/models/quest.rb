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
# - main_quest_slides (String | nil): comma separated slide list for main
# quests. nil if quest is not a main quest.
#
class Quest < ActiveRecord::Base
  include Parts::WithLocking

  belongs_to :parent, :class_name => "Quest"
  # FK :dependent => :delete_all
  has_many :children, :class_name => "Quest", :foreign_key => "parent_id"
  # FK :dependent => :delete_all
  has_many :quest_progresses
  # FK :dependent => :delete_all
  has_many :objectives

  scope :quest, :conditions => {:achievement => false}
  scope :achievement, :conditions => {:achievement => true}

  custom_serialize :rewards,
    :serialize => lambda { |rewards| rewards.nil? ? nil : rewards.to_json },
    :unserialize => lambda { |json| json.nil? ? nil : Rewards.from_json(json) }

  def to_s
    "<Quest(#{id}, p #{parent_id.inspect}) ach: #{achievement?}, slides: #{
      main_quest_slides}>"
  end

  def quest?; ! achievement?; end

  # Return +Quest+ as +Hash+.
  def as_json(options=nil)
    {
      :id => id,
      :rewards => rewards.as_json(options),
      :main_quest_slides => main_quest_slides,
    }
  end

  class << self
    # Returns nested hash of quests.
    #
    # Example:
    # [
    #   {
    #     :quest => Quest#as_json,
    #     :progress => QuestProgress#as_json,
    #     :objectives => [
    #       {
    #         :objective => Objective#as_json,
    #         :progress => nil (if completed) or ObjectiveProgress#as_json
    #       },
    #       ...
    #     ]
    #   },
    #   ...
    # ]
    #
    def hash_all_for_player_id(player_id)
      objective_progresses = ObjectiveProgress.where(:player_id => player_id
        ).all.hash_by { |item| item.objective_id }

      QuestProgress.where(
        :player_id => player_id,
        :quests => {:achievement => false}
      ).includes(:quest => :objectives).map do |quest_progress|
        {
          :quest => quest_progress.quest.as_json,
          :progress => quest_progress.as_json,
          :objectives => quest_progress.quest.objectives.map do |objective|
            {
              :objective => objective.as_json,
              :progress => objective_progresses[objective.id].as_json
            }
          end
        }
      end
    end

    # Returns player achievements.
    #
    # Array of Hashes:
    # [
    #   {
    #     "completed" => Boolean,
    #     "type" => String (objective type),
    #     "key" => String (objective key filter),
    #     "level" => String (objective level filter),
    #     "alliance" => Boolean (is this achievement alliance enabled?),
    #     "npc" => Boolean (objective NPC filter),
    #     "limit" => Fixnum | nil (objective limit filter),
    #     "count => Fixnum (number of times objective has to be completed),
    #     "outcome" => Fixnum (outcome for battle),
    #   },
    #   ...
    # ]
    #
    def achievements_by_player_id(player_id, achievement_ids=nil)
      (achievement_ids.nil? ? self : where(:id => achievement_ids)).
        achievement.
        select("qp.status, o.type, o.key, o.level, o.alliance, " +
          "o.npc, o.limit, o.count, o.outcome").
        joins("LEFT JOIN `#{QuestProgress.table_name}` AS qp
          ON `#{table_name}`.id=qp.quest_id AND qp.player_id=#{
          player_id.to_i} AND qp.status=#{QuestProgress::STATUS_COMPLETED}"
        ).
        joins("LEFT JOIN `#{Objective.table_name}` AS o
          ON `#{table_name}`.id=o.quest_id").
        c_select_all.map do |row|
          row["completed"] = ! row.delete("status").nil?
          row["alliance"] = row["alliance"] == 1
          row["npc"] = row["npc"] == 1
          row
        end
    end

    # Returns achievement for _player_id_ and _achievement_id_. Format is same
    # as in #achievements_by_player_id
    def get_achievement(achievement_id, player_id=0)
      achievements = achievements_by_player_id(player_id, [achievement_id])
      raise ActiveRecord::RecordNotFound.new(
        "Cannot find achievement by id #{achievement_id}!"
      ) if achievements.size == 0
      achievements[0]
    end

    # Start child quests for given player.
    def start_child_quests(parent_id, player_id)
      Quest.where(:parent_id => parent_id).each do |quest|
        begin
          quest_progress = QuestProgress.new(:quest_id => quest.id,
            :player_id => player_id, :status => QuestProgress::STATUS_STARTED)
          quest_progress.save!
        rescue ActiveRecord::RecordNotUnique => e
          # WTF, this should not be happening!
          LOGGER.warn "QuestProgress not unique for player id #{player_id
            }, quest #{quest}.\n\n#{e.to_s}"
        end
      end
    end

    # Optimized version of #start_child_quests which is used on player creation.
    def start_player_quest_line(player_id)
      quest_ids = Quest.select("`id`").where(parent_id: nil).c_select_values
      quest_progresses = quest_ids.map do |quest_id|
        QuestProgress.new(player_id: player_id, quest_id: quest_id)
      end
      BulkSql::QuestProgress.save(quest_progresses)

      objective_ids = Objective.select("`id`").where(quest_id: quest_ids).
        c_select_values
      objective_progresses = objective_ids.map do |objective_id|
        ObjectiveProgress.new(player_id: player_id, objective_id: objective_id)
      end
      BulkSql::ObjectiveProgress.save(objective_progresses)
    end
  end
end