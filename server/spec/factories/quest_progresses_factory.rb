Factory.define :quest_progress do |m|
  m.association :quest
  m.association :player
  m.status QuestProgress::STATUS_STARTED
end