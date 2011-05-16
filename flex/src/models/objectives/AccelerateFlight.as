package models.objectives
{
   import utils.ObjectStringsResolver;
   import utils.locale.Localizer;

   public class AccelerateFlight extends ObjectivePart
   {
      public function AccelerateFlight(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {
         return Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.count,
            ObjectStringsResolver.getString('Time', objective.count)]);
      }
   }
}