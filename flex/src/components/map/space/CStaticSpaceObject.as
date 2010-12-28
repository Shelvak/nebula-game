package components.map.space
{
   import models.IStaticSpaceSectorObject;
   import models.location.LocationMinimal;
   
   import spark.components.Group;
   
   public class CStaticSpaceObject extends Group implements ICStaticSpaceSectorObject
   {
      public function CStaticSpaceObject()
      {
         super();
      }
      
      private var _staticObject:IStaticSpaceSectorObject;
      public function set staticObject(value:IStaticSpaceSectorObject) : void
      {
         if (_staticObject != value)
         {
            _staticObject = value;
            width  = _staticObject.componentWidth;
            height = _staticObject.componentHeight;
         }
      }
      public function get staticObject() : IStaticSpaceSectorObject
      {
         return _staticObject;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _staticObject.currentLocation;
      }
   }
}