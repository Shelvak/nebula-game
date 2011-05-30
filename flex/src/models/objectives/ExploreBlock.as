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
         return Localizer.string('Objectives', 'objectiveText.'+
            objective.type, [objective.count, Math.max(0, objective.scientists)]);
      }
      
   }
}