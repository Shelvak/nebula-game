package models.objectives
{
   import utils.locale.Localizer;

   public class HavePoints extends ObjectivePart
   {
      public function HavePoints(_objective: Objective)
      {
         super(_objective);
      }
      
      
      public override function get objectiveText():String
      {
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type, 
            [objective.limit]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
      
   }
}