package models.objectives
{
   import flash.display.BitmapData;
   
   import utils.ObjectStringsResolver;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;

   public class Battle extends ObjectivePart
   {
      public function Battle(_objective:Objective)
      {
         super(_objective);
      }
      
      public override function get objectiveText(): String
      {
         return Localizer.string('Objectives', 'objectiveText.'+objective.type
            +objective.outcome,
            [objective.count,
               ObjectStringsResolver.getString('Battle', objective.count)]);
      }
      
      public override function get image():BitmapData
      {
         return ImagePreloader.getInstance().getImage(
         AssetNames.getAchievementImageName(objective.type, objective.key) + 
         objective.outcome);
      }
   }
}