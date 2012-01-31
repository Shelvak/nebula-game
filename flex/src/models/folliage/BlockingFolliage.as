package models.folliage
{
   import flash.display.BitmapData;
   import flash.geom.Point;

   import models.tile.FolliageTileKind;

   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   /**
    * Foliage that blocks construction of buildings.
    */
   public class BlockingFolliage extends Folliage
   {
      /**
       * Sets size of the given foliage. Takes size values from
       * <code>FoliageTileKind</code>.
       *
       * @return the given foliage
       */
      public static function setSize(foliage: BlockingFolliage): BlockingFolliage {
         Objects.paramNotNull("foliage", foliage);
         const size: Point = FolliageTileKind.getSize(foliage.kind);
         foliage.setSize(size.x, size.y);
         return foliage;
      }

      private var _kind: int = FolliageTileKind._3X3;
      /**
       * Kind of blocking foliage. Use constants from
       * <code>FoliageTileKind</code> class.
       *
       * <p>Setting this property will dispatch
       * <code>MPlanetObjectEvent.IMAGE_CHANGE</code> event.</p>
       *
       * @default FoliageTileKind._3X3
       */
      public function set kind(v: int): void {
         _kind = v;
         dispatchImageChangeEvent();
      }

      /**
       * @private
       */
      public function get kind(): int {
         return _kind;
      }

      [Bindable(event="planetObjectImageChange")]
      override public function get imageData(): BitmapData {
         return ImagePreloader.getInstance().getImage
                   (AssetNames.getBlockingFolliageImageName(terrainType, kind));
      }

      /**
       * Returns <strong><code>true</code></strong>.
       *
       * @see models.planet.MPlanetObject#isBlocking
       */
      override public function get isBlocking(): Boolean {
         return true;
      }
   }
}