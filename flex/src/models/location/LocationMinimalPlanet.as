package models.location
{
   public class LocationMinimalPlanet extends LocationMinimalSolarSystem
   {
      /**
       * @copy LocationMinimalWrapperBase#LocationMinimalWrapperBase()
       */
      public function LocationMinimalPlanet(location:LocationMinimal = null)
      {
         super(location);
      }
      
      
      protected override function get typeDefault() : uint
      {
         return LocationType.SS_OBJECT;
      }
   }
}