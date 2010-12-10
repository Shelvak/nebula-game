package models.quest
{
   import models.BaseModel;
   
   import utils.ObjectStringsResolver;
   
   public class QuestObjective extends BaseModel
   {
      public var questId: int;
      
      public var progressId: int;
      
      public var type: String;
      
      public var key: String;
      
      public var count: int = 1;
      
      public var completed: int;
      
      public var level: int = 0;
      
      public var alliance: Boolean;
      
      public var npc: Boolean;
      
      [Bindable (event="statusChange")]
      public function get objectiveText(): String
      {
         throw new Error('You must override objective text getter');
      }
   }
}