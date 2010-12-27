package models.location
{
   import utils.MathUtil;

   public class LocationMinimalSolarSystem extends LocationMinimalWrapperBase
   {
      /**
       * @copy LocationMinimalWrapperBase#LocationMinimalWrapperBase()
       */
      public function LocationMinimalSolarSystem(location:LocationMinimal = null)
      {
         super(location);
      }
      
      
      protected override function get typeDefault() : uint
      {
         return LocationType.SOLAR_SYSTEM;
      }
      
      
      /**
       * Angle that defines a ray on which a sector is located. Measured in
       * degrees with respect to X-axis in counterclockwise direction.
       */
      public function set angle(value:int) : void
      {
         location.y = value;
      }
      /**
       * @private
       */
      public function get angle() : int
      {
         return location.y;
      }
      
      
      /**
       * Same as <code>angle</code> just measured in radians. 
       */	   
      public function get angleRadians() : Number
      {
         return MathUtil.degreesToRadians(angle);
      }
      
      
      /**
       * Number of the orbit. An orbit is just an ellipse (or maybe a circle)
       * around a star of a solar system.
       */
      public function set position(value:int) : void
      {
         location.x = value;
      }
      /**
       * @private
       */
      public function get position() : int
      {
         return location.x;
      }
   }
}