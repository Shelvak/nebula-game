package models.solarsystem
{
   import models.BaseModel;

   [Bindable]
   /**
    * Aggregates solar system metadata boolean variables. Variables indicate
    * if player, allies of the player or enemy players have ships or planets
    * in the solar system.
    */ 
   public class MSSMetadata extends BaseModel
   {
      [Required]
      public var playerPlanets: Boolean = false;
      
      
      [Required]
      public var playerShips: Boolean = false;
      
      
      [Required]
      public var alliancePlanets: Boolean = false;
      
      
      [Required]
      public var allianceShips: Boolean = false;
      
      
      [Required]
      public var enemyPlanets: Boolean = false;
      
      
      [Required]
      public var enemyShips: Boolean = false;
      
      
      [Required]
      public var napPlanets: Boolean = false;
      
      
      [Required]
      public var napShips: Boolean = false;
      
      
      public function reset() : void
      {
         playerPlanets =
         playerShips =
         alliancePlanets = 
         allianceShips =
         enemyPlanets = 
         enemyShips = 
         napPlanets = 
         napShips = false;
      }
      
      /**
       * Does the player has any ships or planets in a solar system?
       */ 
      public function get playerAssets() : Boolean {
         return playerPlanets || playerShips;
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String {
         return "[class: " + className +
                ", playerPlanets: " + playerPlanets +
                ", playerShips: " + playerShips +
                ", alliancePlanets: " + alliancePlanets +
                ", allianceShips: " + allianceShips +
                ", napPlanets: " + napPlanets +
                ", napShips: " + napShips +
                ", enemyPlanets: " + enemyPlanets +
                ", enemyShips: " + enemyShips + "]";
      }
   }
}