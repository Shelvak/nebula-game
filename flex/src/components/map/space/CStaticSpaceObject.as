package components.map.space
{
   import flash.errors.IllegalOperationError;
   
   import models.IMStaticSpaceObject;
   import models.location.LocationMinimal;
   
   import spark.components.Group;
   
   public class CStaticSpaceObject extends Group implements ICStaticSpaceObject
   {
      public function CStaticSpaceObject()
      {
         super();
      }
      
      
      private var _staticObject:IMStaticSpaceObject;
      public function set staticObject(value:IMStaticSpaceObject) : void
      {
         if (_staticObject != value)
         {
            _staticObject = value;
            width  = _staticObject.componentWidth;
            height = _staticObject.componentHeight;
         }
      }
      public function get staticObject() : IMStaticSpaceObject
      {
         return _staticObject;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _staticObject.currentLocation;
      }
   }
}