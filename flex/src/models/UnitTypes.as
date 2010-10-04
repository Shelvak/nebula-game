package models
{
   import config.Config;

   public class UnitTypes
   {
      /**
       * Lets you find out if given constructable type is a unit.
       * 
       * @param type constructable type in CamelCase notation
       * 
       * @return <code>true</code> if given constructuble type is a unit
       * or <code>false</code> otherwise 
       */
      public static function isUnit(type:String) : Boolean
      {
         return Config.allUnitTypes.contains(type);
      }
      
      
      /**
       * Lets you find out if given constructable type is a building.
       * 
       * @param type constructable type in CamelCase notation
       * 
       * @return <code>true</code> if given constructuble type is a building
       * or <code>false</code> otherwise
       */
      public static function isBuilding(type:String) : Boolean
      {
         return Config.allBuildingTypes.contains(type);
      }
   }
}