package models.solarsystem
{
   import models.Owner;


   /**
    * Defines string type constants of available solar system metadata type
    * (actually name of status image). Used in <code>SolarSystemTileSkin</code> and
    * </code>ImagePreloader</code>. 
    */   
   public final class SSMetadataType
   {
      public static const PLAYER_PLANETS: String = "playerPlanets";
      public static const PLAYER_SHIPS: String = "playerShips";
      public static const ALLIANCE_PLANETS: String = "alliancePlanets";
      public static const ALLIANCE_SHIPS: String = "allianceShips";
      public static const ENEMY_PLANETS: String = "enemyPlanets";
      public static const ENEMY_SHIPS: String = "enemyShips";
      public static const NAP_PLANETS: String = "napPlanets";
      public static const NAP_SHIPS: String = "napShips";
      public static const NPC_SHIPS: String = "npcShips";

      public static function getConstantNamePrefixFor(owner: int): String {
         switch (owner) {
            case Owner.PLAYER: return "PLAYER";
            case Owner.ALLY: return "ALLIANCE";
            case Owner.ENEMY: return "ENEMY";
            case Owner.NAP: return "NAP";
            case Owner.NPC: return "NPC";
            default:
               throw new ArgumentError(
                  "[param owner] may only hold Owner.PLAYER (" + Owner.PLAYER
                     + "), Owner.ALLY (" + Owner.ALLY
                     + "), Owner.NAP (" + Owner.NAP
                     + "), Owner.ENEMY (" + Owner.ENEMY
                     + "), Owner.NPC (" + Owner.NPC
                     + ") but was " + owner)
         }
      }
   }
}