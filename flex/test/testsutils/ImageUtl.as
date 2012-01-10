package testsutils
{
   import models.solarsystem.SSMetadataType;

   import namespaces.client_internal;

   import utils.ObjectPropertyType;

   import utils.Objects;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;


   public class ImageUtl
   {
      private static function get IMG(): ImagePreloader {
         return ImagePreloader.getInstance();
      }

      public static function add(name:String): void {
         IMG.client_internal::addFrames(name);
      }

      public static function addSSMetadataIcons(): void {
         Objects.forEachStaticValue(
            SSMetadataType,
            ObjectPropertyType.STATIC_CONST,
            function(iconType: String): void {
               add(AssetNames.getSSStatusIconName(iconType));
            }
         );
      }

      public static function tearDown(): void {
         IMG.client_internal::clearFrames();
      }
   }
}
