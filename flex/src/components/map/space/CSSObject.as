package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectImage;
   
   import models.solarsystem.SSObject;
   
   import spark.components.Label;
   import spark.primitives.BitmapImage;

   public class CSSObject extends CStaticSpaceObject
   {
      public function CSSObject()
      {
         super();
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var imgImage:SSObjectImage;
      private var lblName:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         imgImage = new SSObjectImage();
         imgImage.model = SSObject(staticObject);
         imgImage.transformX = width / 2;
         imgImage.transformY = height / 2;
         imgImage.width  = width;
         imgImage.height = height;
         imgImage.verticalCenter =
         imgImage.horizontalCenter = 0;
         imgImage.rotation = SSObject(staticObject).angle + 180
         addElement(imgImage);
         
         lblName = new Label();
         lblName.horizontalCenter = 0;
         lblName.bottom = -16;
         lblName.name = SSObject(staticObject).name;
         addElement(lblName);
      }
   }
}