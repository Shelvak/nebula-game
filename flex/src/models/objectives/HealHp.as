package models.objectives
{
   import utils.locale.Localizer;

   public class HealHp extends ObjectivePart
   {
      public function HealHp(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.count]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}