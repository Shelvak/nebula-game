# Class for representing a quest and all it's assets in client.
class ClientQuest
  attr_reader :quest_id, :player_id

  include Parts::Object

  def initialize(quest_id, player_id)
    @quest_id = quest_id
    @player_id = player_id
  end

  def quest; Quest.find(@quest_id); end
  def player; Player.find(@player_id); end

  # Returns hash of single quest.
  #
  # Example:
  # {
  #   :quest => Quest,
  #   :progress => QuestProgress,
  #   :objectives => [
  #     {
  #       :objective => Objective,
  #       :progress => nil (if completed) or ObjectiveProgress
  #     },
  #     ...
  #   ]
  # }
  #
  def as_json(options=nil)
    quest_progress = QuestProgress.where(
      :quest_id => @quest_id, :player_id => @player_id
    ).includes(:quest => :objectives).first

    objective_ids = quest_progress.quest.objectives.map(&:id)

    objective_progresses = ObjectiveProgress.where(:player_id => @player_id,
      :objective_id => objective_ids).all.hash_by { |op| op.objective_id }

    {
      :quest => quest_progress.quest,
      :progress => quest_progress,
      :objectives => quest_progress.quest.objectives.map do |objective|
        objective_progress = objective_progresses[objective.id]
        {
          :objective => objective,
          :progress => objective_progress \
            ? objective_progress : nil
        }
      end
    }
  end
end