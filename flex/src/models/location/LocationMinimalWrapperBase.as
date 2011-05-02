package models.location
{
   public class LocationMinimalWrapperBase implements ILocation
   {
      /**
       * Constructor.
       * 
       * @param location instance of <code>LocationMinimal</code> to wrap. You will be able to
       * set it later with <code>setLocation()</code> method.
       * 
       * @see #setLocation()
       */
      public function LocationMinimalWrapperBase(location:LocationMinimal = null)
      {
         this.location = location;
      }
      
      
      private var _location:LocationMinimal;
      /**
       * Wrapped instance of <code>LocationMinimal</code>.
       */
      public function set location(location:LocationMinimal) : void
      {
         _location = location;
      }
      /**
       * @private
       */
      public function get location() : LocationMinimal
      {
         return _location;
      }
      
      
      public function set type(value:uint):void
      {
         location.type = value;
      }
      public function get type():uint
      {
         return location.type;
      }
      
      
      public function set id(value:int) : void
      {
         location.id = value;
      }
      public function get id() : int
      {
         return location.id;
      }
      
      
      public function set x(value:int) : void
      {
         location.x = value;
      }
      public function get x() : int
      {
         return location.x;
      }
      
      
      public function set y(value:int) : void
      {
         location.y = value;
      }
      public function get y() : int
      {
         return location.y;
      }
   }
}