package models.objectives
{
   import models.exploration.ExplorationStatus;
   
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;
   
   
   public class ExploreBlock extends ObjectivePart
   {
      public function ExploreBlock(_objective: Objective)
      {
         super(_objective);
      }
      
      public var limit: int;
      
      
      public override function get objectiveText():String
      {
         var scientists: int = ExplorationStatus.calculateNeededScientists(limit, 1);
         var text: String = Localizer.string('Objectives', 'objectiveText.'+
            objective.type+
            (objective.scientists > 0?'1':'0'), [
            (objective.count > 1 ? objective.count + ' ' : ''),
            ObjectStringsResolver.getString('Time', objective.count), 
            objective.scientists]);
         if (text == null)
         {
            throw new Error("Objective text creation failed, "+objective.type+
               ', count: '+objective.count+', limit: '+limit);
         }
         return text;
      }
      
   }
}