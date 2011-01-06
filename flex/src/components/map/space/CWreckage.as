package components.map.space
{
   import flash.filters.GlowFilter;
   
   import models.IMStaticSpaceObject;
   import models.location.LocationMinimal;
   
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   
   
   public class CWreckage extends Group implements ICStaticSpaceObject
   {
      public function CWreckage()
      {
         super();
         filters = [new GlowFilter(0, 1, 24, 24, 3.5)];
      }
      
      
      private var _image:BitmapImage;
      protected override function createChildren() : void
      {
         super.createChildren();
         _image = new BitmapImage();
         with (_image)
         {
            left = right = top = bottom = 0;
            smooth = true;
         }
         addElement(_image);
      }
      
      
      private var f_staticObjectChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_staticObjectChanged && _staticObject)
         {
            width  = _staticObject.componentWidth;
            height = _staticObject.componentHeight;
            _image.source = _staticObject.imageData;
         }
         
         f_staticObjectChanged = false;
      }
      
      
      private var _staticObject:IMStaticSpaceObject;
      public function set staticObject(value:IMStaticSpaceObject) : void
      {
         if (_staticObject != value)
         {
            _staticObject = value;
            f_staticObjectChanged = true;
            invalidateProperties();
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