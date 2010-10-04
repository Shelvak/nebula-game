package models.solarsystem
{
   import models.BaseModel;

   [Bindable]
   /**
    * Aggregates solar system metadata boolean variables. Varibles indicate
    * if player, allies of the palyer or enemy players have ships or planets
    * in the solar system.
    */ 
   public class SSMetadata extends BaseModel
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
      
      public function getProperty (name: String) :Boolean
      {
         return this[name];
      }
   }
}