package components.gameobjects.planet
{
   /**
    * Defines colors of <code>PlanetObjectBasement</code> at different object states like building
    * can be built / can't be built.
    */
   public final class PlanetObjectBasementColor
   {
      /**
       * Default color of the basement.
       */
      public static const DEFAULT:int = 0x00FF00;
      
      
      /**
       * Building can be built at a location.
       */
      public static const BUILDING_OK:int = DEFAULT;
      
      
      /**
       * Building can't be built due to some obstacle at a location.
       */      
      public static const BUILDING_RESTRICTED:int = 0xFF0000;
   }
}