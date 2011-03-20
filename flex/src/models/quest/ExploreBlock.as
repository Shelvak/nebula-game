package models.quest
{
   import models.exploration.ExplorationStatus;
   
   import utils.locale.Localizer;
   import utils.ObjectStringsResolver;
   
   
   public class ExploreBlock extends QuestObjective
   {
      public function ExploreBlock()
      {
         super();
      }
      
      public var limit: int;
      
      
      public override function get objectiveText():String
      {
         var scientists: int = ExplorationStatus.calculateNeededScientists(limit, 1);
         var text: String = Localizer.string('Quests', 'objectiveText.'+type, [
            Localizer.string('Quests', 'objective.'+type),
            (count > 1 ? count + ' ' : ''), scientists, completed,
         count]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+type+', count: '+count+', limit: '+limit);
         }
         return text;
      }
      
   }
}