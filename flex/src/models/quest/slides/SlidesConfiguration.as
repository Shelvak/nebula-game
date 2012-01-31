package models.quest.slides
{
   public final class SlidesConfiguration
   {
      public static const KEY_QUEST:String = "Quest";
      public static const KEY_QUEST_WITH_IMAGE:String = "QuestWithImage";
      public static const KEY_BG_BATTLES:String = "BgBattles";
      public static const KEY_BOSS_SHIP:String = "BossShip";
      public static const KEY_ECO_TIER2:String = "EcoTier2";
      public static const KEY_GALAXY_BATTLES:String = "GalaxyBattles";
      public static const KEY_ORE_TILE:String = "OreTile";
      public static const KEY_PULSARS:String = "Pulsars";
      public static const KEY_RADAR2:String = "Radar2";
      public static const KEY_RESOURCES:String = "Resources";
      public static const KEY_ZETIUM_TILE:String = "ZetiumTile";

      private static const BACKGROUNDS_WITHOUT_LOC:Array = [
         KEY_QUEST, KEY_QUEST_WITH_IMAGE, KEY_BG_BATTLES, KEY_BOSS_SHIP,
         KEY_ECO_TIER2, KEY_GALAXY_BATTLES, KEY_ORE_TILE, KEY_PULSARS,
         KEY_RADAR2, KEY_RESOURCES, KEY_ZETIUM_TILE
      ];

      public static function backgroundNeedsLocalization(key:String): Boolean {
         return BACKGROUNDS_WITHOUT_LOC.indexOf(key) == -1;
      }
   }
}
