package components.map.space
{
   import flash.filters.GlowFilter;
   
   import models.map.IMStaticSpaceObject;
   import models.MWreckage;
   
   import spark.primitives.BitmapImage;
   
   
   public class CWreckage extends CStaticSpaceObject
   {
      public function CWreckage() {
         super();
         filters = [new GlowFilter(0, 1, 24, 24, 3.5)];
      }
      
      private var _image:BitmapImage;
      
      protected override function createChildren() : void {
         super.createChildren();
         
         _image = new BitmapImage();
         _image.left = 0;
         _image.right = 0;
         _image.top = 0;
         _image.bottom = 0;
         _image.smooth = true;
         addElement(_image);
      }
      
      private var f_staticObjectChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         if (f_staticObjectChanged && staticObject != null) {
            _image.source = MWreckage(staticObject).imageData;
         }
         
         f_staticObjectChanged = false;
      }
      
      public override function set staticObject(value:IMStaticSpaceObject) : void {
         if (super.staticObject != value) {
            super.staticObject = value;
            f_staticObjectChanged = true;
            invalidateProperties();
         }
      }
   }
}