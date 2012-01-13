package models.quest.slides
{
   import flash.geom.Rectangle;


   public final class SlidesConfiguration
   {
      public static const KEY_QUEST:String = "Quest";
      public static const KEY_QUEST_WITH_IMAGE:String = "QuestWithImage";
      public static const KEY_BUILDING_SIDEBAR:String = "BuildingSidebar";
      public static const KEY_CLAIM_REWARD:String = "ClaimReward";
      public static const KEY_ORE_TILE:String = "OreTile";

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

      private static const TEXT_AREA:Object = new Object();
      TEXT_AREA[KEY_BUILDING_SIDEBAR] = textArea(10, 10, 390, 410);
      TEXT_AREA[KEY_CLAIM_REWARD] = textArea(290, 60, 665, 410);
      TEXT_AREA[KEY_ORE_TILE] = textArea(260, 160, 665, 410);

      public static function getSimpleSlideTextPosition(key:String): Rectangle {
         return TEXT_AREA[key];
      }

      private static function textArea(x:int, y:int, xEnd:int, yEnd:int) : Rectangle {
         return new Rectangle(x, y, xEnd - x, yEnd - y);
      }
   }
}
