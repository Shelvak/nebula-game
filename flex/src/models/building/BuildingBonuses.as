package models.building
{
   import config.Config;

   /**
    * Holds bonus values (armor, energy output, construction time)
    * of a building. All values must be treated as percentage. 
    */   
   public class BuildingBonuses
   {
      /**
       * Base value of all bonus values is 2%. 
       */      
      public static const BASE_VALUE: Number = 2;
      
      
      public var armor:Number;
      public var energyOutput:Number;
      public var constructionTime:Number;
      
      
      /**
       * Constructor. 
       */
      public function BuildingBonuses()
      {
         reset();
      }
      
      public static function refreshBonuses(tiles: Array):BuildingBonuses
      {
         var totalBonus: BuildingBonuses = new BuildingBonuses();
         for each (var element: int in tiles)
         totalBonus = getBonusesSum(totalBonus, Config.getTileMod(element));
         return totalBonus; 
      }
      
      public static function getBonusesSum(a: BuildingBonuses, b: BuildingBonuses): BuildingBonuses
      {
         a.constructionTime += b.constructionTime;
         a.energyOutput += b.energyOutput;
         a.armor += b.armor;
         return a;
      } 
      
      /**
       * Sets all properties to their default values (zeroes that is). 
       */
      public function reset() : void
      {
         armor = 0;
         energyOutput = 0;
         constructionTime = 0;
      }
   }
}