package models.objectives
{
   import utils.ObjectFormType;
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;

   public class Accelerate extends ObjectivePart
   {
      public function Accelerate(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {         
         return Localizer.string('Objectives', 'objectiveText.'+
            objective.type+objective.key, [objective.count]);
      }
   }
}