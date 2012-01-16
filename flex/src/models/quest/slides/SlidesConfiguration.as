package models.quest.slides
{
   public final class SlidesConfiguration
   {
      public static const KEY_QUEST:String = "Quest";
      public static const KEY_QUEST_WITH_IMAGE:String = "QuestWithImage";
      public static const KEY_BUILDING_SIDEBAR:String = "BuildingSidebar";
      public static const KEY_CLAIM_REWARD:String = "ClaimReward";

      private static const LOC_BACKGROUNDS:Array = [
         KEY_BUILDING_SIDEBAR, KEY_CLAIM_REWARD
      ];

      public static function backgroundNeedsLocalization(key:String): Boolean {
         return LOC_BACKGROUNDS.some(
            function(slideKey:String, index:int, array:Array): Boolean {
               return slideKey == key;
            }
         );
      }
   }
}
