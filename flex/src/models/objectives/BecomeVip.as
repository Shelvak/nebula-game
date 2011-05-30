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
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.level, objective.count]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}