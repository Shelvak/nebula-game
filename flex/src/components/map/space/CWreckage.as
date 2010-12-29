package components.map.space
{
   import models.IMStaticSpaceObject;
   import models.location.LocationMinimal;
   
   import spark.primitives.BitmapImage;
   
   
   public class CWreckage extends BitmapImage implements ICStaticSpaceObject
   {
      public function CWreckage()
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
            source = _staticObject.imageData;
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