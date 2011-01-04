package models.location
{
   public class LocationMinimalGalaxy extends LocationMinimalWrapperBase
   {
      /**
       * @copy LocationMinimalWrapperBase#LocationMinimalWrapperBase()
       */
      public function LocationMinimalGalaxy(location:LocationMinimal = null)
      {
         super(location);
      }
      
      
      /**
       * Sector X coordinate in a galaxy.
       */
      public function set x(value:int) : void
      {
         location.x = value;
      }
      /**
       * @private
       */
      public function get x() : int
      {
         return location.x;
      }
      
      
      /**
       * Sector Y coordinate in a galaxy.
       */
      public function set y(value:int) : void
      {
         location.y = value;
      }
      /**
       * @private
       */
      public function get y() : int
      {
         return location.y;
      }
   }
}