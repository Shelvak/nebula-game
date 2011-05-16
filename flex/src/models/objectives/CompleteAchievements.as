package models.objectives
{
   import utils.locale.Localizer;

   public class CompleteAchievements extends ObjectivePart
   {
      public function CompleteAchievements(_objective:Objective)
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