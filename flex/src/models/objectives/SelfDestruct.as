package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;

   public class SelfDestruct extends ObjectivePart
   {
      public function SelfDestruct(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {
         return Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.count]);
      }
   }
}