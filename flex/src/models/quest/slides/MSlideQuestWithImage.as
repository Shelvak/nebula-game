package models.quest.slides
{
   import controllers.objects.ObjectClass;

   import flash.display.BitmapData;

   import models.quest.MainQuestSlideKey;
   import models.quest.Quest;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;


   public class MSlideQuestWithImage extends MSlide
   {
      private var _imageClass:String;
      private var _imageSubclass:String;

      public function MSlideQuestWithImage(key:String, quest:Quest) {
         super(key, quest);
         _imageClass = MainQuestSlideKey.getImageClass(key).toLowerCase();
         _imageSubclass = MainQuestSlideKey.getImageSubclass(key);
      }

      public function get imageIsTechnology(): Boolean {
         return _imageClass == ObjectClass.TECHNOLOGY;
      }
      
      public function get imageIsUnit(): Boolean {
         return _imageClass == ObjectClass.UNIT;
      }

      public function get imageIsBuilding(): Boolean {
         return _imageClass == ObjectClass.BUILDING;
      }

      public function get image(): BitmapData {
         var imageName:String;
         if (imageIsUnit) {
            imageName = AssetNames.getUnitImageName(_imageSubclass);
         }
         else if (imageIsBuilding) {
            imageName = AssetNames.getBuildingImageName(_imageSubclass);
         }
         else {
            imageName = AssetNames.getTechnologyImageName(_imageSubclass);
         }
         return ImagePreloader.getInstance().getImage(imageName);
      }
   }
}
