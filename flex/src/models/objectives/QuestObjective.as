package models.objectives
{
   import models.BaseModel;
   import models.quest.events.QuestEvent;
   
   import utils.ObjectStringsResolver;
   
   public class QuestObjective extends Objective
   {
      public function QuestObjective(_type: String)
      {
         super(_type);
      }
      
      public var questId: int;
      
      private var _completed: int;
      
      public function set completed(value: int): void
      {
         _completed = value;
         dispatchCompletedChangeEvent();
      }
      
      [Bindable (event="completedChange")]
      public function get completed(): int
      {
         return _completed;
      }
      
      [Bindable (event="completedChange")]
      public override function get objectiveText(): String
      {
         return super.objectiveText + ' ('+ completed + '/'+ count+')';
      }
      
      public function dispatchCompletedChangeEvent(): void
      {
         if (hasEventListener(QuestEvent.COMPLETED_CHANGE))
         {
            dispatchEvent(new QuestEvent(QuestEvent.COMPLETED_CHANGE));
         }
      }
   }
}