package models.folliage
{
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   import flash.display.BitmapData;
   
   import models.tile.FolliageTileKind;

   
   /**
    * Folliage that blocks construction of buildings.
    */
   public class BlockingFolliage extends Folliage
   {
      private var _kind:int = FolliageTileKind._3X3;
      /**
       * Kind of blocking foliage. Use constants from
       * <code>FolliageTileKind</code> class.
       * 
       * <p>Setting this property will dispatch
       * <code>MPlanetObjectEvent.IMAGE_CHANGE</code> event.</p>
       * 
       * @default FolliageTileKind._3X3
       */
      public function set kind(v:int) : void
      {
         _kind = v;
         dispatchImageChangeEvent();
      }
      /**
       * @private
       */
      public function get kind() : int
      {
         return _kind;
      }
      
      
      [Bindable(event="planetObjectImageChange")]
      override public function get imageData() : BitmapData
      {
         return ImagePreloader.getInstance().getImage
            (AssetNames.getBlockingFolliageImageName(terrainType, kind));
      }
      
      
      /**
       * Returns <strong><code>true</code></strong>.
       * 
       * @see models.planet.MPlanetObject#isBlocking
       */
      override public function get isBlocking() : Boolean
      {
         return true;
      }
   }
}