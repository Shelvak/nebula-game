package models.quest
{
   import models.BaseModel;
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.quest.events.QuestEvent;
   
   import utils.locale.Localizer;
   import models.Reward;

   [Bindable]
   public class Quest extends BaseModel
   {
      public function Quest()
      {
         super();
         addEventListener(QuestEvent.STATUS_CHANGE, refreshObjectives);
      }
      /**
      * hash of rewards
      * 'metal' => Fixnum,
      * 'energy' => Fixnum,
      * 'zetium' => Fixnum,
      * 'points' => Fixnum,
      * 'units' => 
      * [
      *    {'type' => "Trooper", 'level' => 2, 'count' => 2}
      * ]
      */      
      public var rewards: Reward;
      
      /**
       * ID of help article associated to this quest in knowledge base.
       */      
      [Optional]
      public var helpUrlId: String;
      
      public static const STATUS_STARTED: int = 0;
      public static const STATUS_COMPLETED: int = 1;
      public static const STATUS_REWARD_TAKEN: int = 2;
      
      public var status: int;
      
      public var completed: int;
      
      public var objectives: ModelsCollection;
      
      public function getProgressArray(current: int): Array
      {
         return [current, objectives.length];
      }
      
      public function findObjectiveByProgress(progressId: int): QuestObjective
      {
         for each (var objective: QuestObjective in objectives)
         {
            if (objective.progressId == progressId)
            {
               return objective;
            }
         }
         return null;
      }
      
      public function get title(): String
      {
         var rTitle: String = Localizer.string('Quests', 'title.' + id);
         if (rTitle == null)
         {
            throw new Error ("Quest title with id "+id+" not found!");
         }
         return rTitle;
      }
      
      public function get about(): String
      {
         var rAbout: String = Localizer.string('Quests', 'about.' + id);
         if (rAbout == null)
         {
            throw new Error ("Quest description with id "+id+" not found!");
         }
         return rAbout;
      }
      
      public function refreshObjectives(e: QuestEvent): void
      {
         for each (var objective: QuestObjective in objectives)
         {
            objective.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
         }
         ModelLocator.getInstance().quests.applyCurrentFilter();
      }
   }
}