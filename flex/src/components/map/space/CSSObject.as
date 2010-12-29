package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectImage;
   
   import models.solarsystem.MSSObject;
   
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
         
         var ssObject:MSSObject = MSSObject(staticObject);
         
         imgImage = new SSObjectImage();
         with (imgImage)
         {
            model            = ssObject;
            transformX       = width / 2;
            transformY       = height / 2;
            width            = width;
            height           = height;
            verticalCenter   = 0;
            horizontalCenter = 0;
            rotation         = ssObject.angle + 180
         }
         addElement(imgImage);
         
         lblName = new Label();
         with (lblName)
         {
            horizontalCenter = 0;
            bottom           = -16;
            name             = ssObject.name;
         }
         addElement(lblName);
      }
   }
}