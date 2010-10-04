package components.menus
{
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   import spark.primitives.BitmapImage;

   public class NavigatorArrow extends BitmapImage
   {
      public function NavigatorArrow ()
      {
         super ();
         source = ImagePreloader.getInstance().getImage
            (AssetNames.UI_IMAGES_FOLDER + "navigator_arrow");
      }
   }
}