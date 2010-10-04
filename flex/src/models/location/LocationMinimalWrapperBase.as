package models.location
{
   import utils.ClassUtil;

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
         _location = location;
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
   }
}