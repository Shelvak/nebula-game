package models.objectives
{
   import models.BaseModel;
   
   import utils.ObjectStringsResolver;
   
   public class QuestObjective extends Objective
   {
      public function QuestObjective(_type: String)
      {
         super(_type);
      }
      
      public var questId: int;
      
      public var completed: int;
      
      public override function get objectiveText(): String
      {
         return super.objectiveText + ' ('+ completed + '/'+ count+')';
      }
   }
}