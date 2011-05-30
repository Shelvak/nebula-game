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
         var result: String = Localizer.string('Objectives', 'objectiveText.'+
            objective.type+objective.key, [objective.count]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}