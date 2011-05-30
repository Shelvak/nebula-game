package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;

   public class BecomeVip extends ObjectivePart
   {
      public function BecomeVip(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {
         return Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.level, objective.count]);
      }
   }
}