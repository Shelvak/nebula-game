package models.location
{
   import flash.errors.IllegalOperationError;
   
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
         this.location = location;
      }
      
      
      private var _location:LocationMinimal;
      /**
       * Wrapped instance of <code>LocationMinimal</code>.
       */
      public function set location(location:LocationMinimal) : void
      {
         _location = location;
         if (_location)
         {
            type = typeDefault;
         }
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
      
      
      /**
       * What location type this wrapper is responsible for. Use one of the constants in
       * <code>LocationType</code> class.
       */
      protected function get typeDefault() : uint
      {
         throw new IllegalOperationError("This method is abstract!");
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