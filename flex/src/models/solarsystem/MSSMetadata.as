package models.solarsystem
{
   import models.BaseModel;
   import models.OwnerType;

   import utils.ObjectStringBuilder;


   public class MSSMetadata extends BaseModel
   {
      [Required]
      public var playerPlanets: Boolean = false;

      [Required]
      public var playerShips: Boolean = false;

      /**
       * Does the player has any ships or planets in a solar system?
       */
      public function get playerAssets() : Boolean {
         return playerPlanets || playerShips;
      }

      public function get playerMetadata(): MSSMetadataOfOwnerType {
         const metadata: MSSMetadataOfOwnerType = new MSSMetadataOfOwnerType(OwnerType.PLAYER);
         if (playerPlanets) {
            metadata.playersWithPlanets = [ML.player];
         }
         if (playerShips) {
            metadata.playersWithShips = [ML.player];
         }
         return metadata;
      }

      [Required(aggregatesProps="alliesWithPlanets, alliesWithShips")]
      [PropsMap(
         alliesWithPlanets="playersWithPlanets",
         alliesWithShips="playersWithShips")]
      public const alliesMetadata: MSSMetadataOfOwnerType =
         new MSSMetadataOfOwnerType(OwnerType.ALLIANCE);

      [Required(aggregatesProps="enemiesWithPlanets, enemiesWithShips")]
      [PropsMap(
         enemiesWithPlanets="playersWithPlanets",
         enemiesWithShips="playersWithShips")]
      public const enemiesMetadata: MSSMetadataOfOwnerType =
         new MSSMetadataOfOwnerType(OwnerType.ENEMY);

      [Required(aggregatesProps="napsWithPlanets, napsWithShips")]
      [PropsMap(
         napsWithPlanets="playersWithPlanets",
         napsWithShips="playersWithShips")]
      public const napsMetadata: MSSMetadataOfOwnerType =
         new MSSMetadataOfOwnerType(OwnerType.NAP);

      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String {
         return new ObjectStringBuilder(this)
            .addProp("playerMetadata")
            .addProp("alliesMetadata")
            .addProp("napsMetadata")
            .addProp("enemiesMetadata").finish();
      }
   }
}
