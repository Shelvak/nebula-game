package models.quest
{
   import models.quest.slides.SlidesConfiguration;

   import utils.ModelUtil;


   public final class MainQuestSlideKey
   {
      public static function isQuestBaseKey(key:String): Boolean {
         return key == SlidesConfiguration.KEY_QUEST;
      }

      public static function isQuestWithImageBaseKey(key:String): Boolean {
         return key.indexOf(SlidesConfiguration.KEY_QUEST_WITH_IMAGE) == 0;
      }

      public static function getImageClass(baseKey:String): String {
         return ModelUtil.getModelClass(getImageType(baseKey));
      }

      public static function getImageSubclass(baseKey:String): String {
         return ModelUtil.getModelSubclass(getImageType(baseKey));
      }

      public static function getQuestFullKey(baseKey:String, quest:Quest): String {
         return baseKey + quest.id;
      }

      private static function getImageType(baseKey:String): String {
         return baseKey.replace(
            SlidesConfiguration.KEY_QUEST_WITH_IMAGE + ":", ""
         );
      }
   }
}
