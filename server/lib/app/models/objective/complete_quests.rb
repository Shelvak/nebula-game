class Objective::CompleteQuests < Objective
  KEY = ""
  def self.resolve_key(klass); KEY; end

  def self.progress(quest_progress); super([quest_progress]); end

  def initial_completed(player_id)
    QuestProgress.joins(:quest).where(
      :player_id => player_id,
      :quests => {:achievement => self.class.achievement?},
      :status => [
        QuestProgress::STATUS_COMPLETED,
        QuestProgress::STATUS_REWARD_TAKEN
      ]).count
  end

  # Used for #initial_completed to determine if we want to calculate
  # achievements or quests.
  def self.achievement?; false; end
end