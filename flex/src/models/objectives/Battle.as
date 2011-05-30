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
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type,
            [objective.count, (objective.outcome==1?'lose':'win')]);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
      
      public override function get image():BitmapData
      {
         return ImagePreloader.getInstance().getImage(
         AssetNames.getAchievementImageName(objective.type, objective.key) + 
         objective.outcome);
      }
   }
}