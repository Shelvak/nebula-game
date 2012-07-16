package components.map.space.galaxy.entiregalaxy
{
   import models.Owner;
   import models.OwnerColor;


   internal final class Colors
   {
      public static const BACKGROUND_COLOR: uint = 0x000000;
      public static const BORDER_COLOR: uint = 0x9bc258;

      private static const SS_COLORS: Object = new Object();
      SS_COLORS[MiniSSType.PLAYER_HOME] = OwnerColor.getColor(Owner.PLAYER);
      SS_COLORS[MiniSSType.ALLIANCE_HOME] = OwnerColor.getColor(Owner.ALLY);
      SS_COLORS[MiniSSType.NAP_HOME] = OwnerColor.getColor(Owner.NAP);
      SS_COLORS[MiniSSType.ENEMY_HOME] = OwnerColor.getColor(Owner.ENEMY);
      SS_COLORS[MiniSSType.REGULAR] = 0xeeff1c;
      SS_COLORS[MiniSSType.PULSAR] = 0x8cbac4;
      SS_COLORS[MiniSSType.WORMHOLE] = 0xb511fb;

      public static function getMiniSSColor(type: String): uint {
         return SS_COLORS[type];
      }
   }
}
