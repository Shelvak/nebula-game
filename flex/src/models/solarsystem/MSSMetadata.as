package models.solarsystem
{
   import models.BaseModel;
   import models.Owner;


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

      public function get playerMetadata(): MSSMetadataOfOwner {

         return new MSSMetadataOfOwner(
            Owner.PLAYER,
            playerPlanets ? [ML.player]: [],
            playerShips ? [ML.player]: []);
      }

      [Required(elementType="models.player.PlayerMinimal")]
      public var alliesWithPlanets: Array = [];

      [Required(elementType="models.player.PlayerMinimal")]
      public var alliesWithShips: Array = [];

      public function get alliesMetadata(): MSSMetadataOfOwner {
         return new MSSMetadataOfOwner(Owner.ALLY, alliesWithPlanets, alliesWithShips);
      }


      [Required(elementType="models.player.PlayerMinimal")]
      public var enemiesWithPlanets: Array = [];

      [Required(elementType="models.player.PlayerMinimal")]
      public var enemiesWithShips: Array = [];

      public function get enemiesMetadata(): MSSMetadataOfOwner {
         return new MSSMetadataOfOwner(Owner.ENEMY, enemiesWithPlanets, enemiesWithShips)
      }


      [Required(elementType="models.player.PlayerMinimal")]
      public var napsWithPlanets: Array = [];

      [Required(elementType="models.player.PlayerMinimal")]
      public var napsWithShips: Array = [];

      public function get napsMetadata(): MSSMetadataOfOwner {
         return new MSSMetadataOfOwner(Owner.NAP, napsWithPlanets, napsWithShips)
      }

      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String {
         return "[class: " + className +
                ", playerPlanets: " + playerPlanets +
                ", playerShips: " + playerShips +
                ", alliesWithPlanets: " + alliesWithPlanets +
                ", alliesWithShips: " + alliesWithShips +
                ", napsWithPlanets: " + napsWithPlanets +
                ", napsWithShips: " + napsWithShips +
                ", enemiesWithPlanets: " + enemiesWithPlanets +
                ", enemiesWithShips: " + enemiesWithShips + "]";
      }
   }
}