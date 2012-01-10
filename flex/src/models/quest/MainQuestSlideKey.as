package models.quest
{
   import utils.ModelUtil;


   public final class MainQuestSlideKey
   {
      public static const BASE_KEY_QUEST:String = "Quest";
      public static const BASE_KEY_QUEST_WITH_IMAGE:String = "QuestWithImage";

      public static function isQuestBaseKey(key:String): Boolean {
         return key == BASE_KEY_QUEST;
      }

      public static function isQuestWithImageBaseKey(key:String): Boolean {
         return key.indexOf(BASE_KEY_QUEST_WITH_IMAGE) == 0;
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
         return baseKey.replace(BASE_KEY_QUEST_WITH_IMAGE + ":", "");
      }
   }
}
