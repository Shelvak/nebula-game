package components.planetmapeditor
{
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import models.planet.MPlanetObject;

   import spark.primitives.BitmapImage;

   import utils.Objects;


   public class CTilePlaceholder
      extends BitmapImage
      implements IPrimitivePlanetMapObject
   {
      public function CTilePlaceholder() {
         super();
      }

      private var _tileObject: MTilePlanetObject = null;
      public function get tileObject(): MPlanetObject {
         return _tileObject;
      }

      private var _tile: IRTileKindM = null;
      public function set tile(value: IRTileKindM): void {
         if (value != null && _tile != value) {
            _tile = value;
            _tileObject = new MTilePlanetObject(value);
            source = _tileObject.imageData;
         }
      }
      public function get tile(): IRTileKindM {
         return _tile;
      }

      /* ################################# */
      /* ### IPrimitivePlanetMapObject ### */
      /* ################################# */

      public function get model(): MPlanetObject {
         return _tileObject;
      }

      public function initModel(model: MPlanetObject): void {
         Objects.throwAbstractMethodError();
      }

      public function setDepth(): void {
         Objects.throwAbstractMethodError();
      }

      public function cleanup(): void {
         Objects.throwAbstractMethodError();
      }
   }
}


import components.map.planet.TileMaskType;
import components.planetmapeditor.IRTileKindM;

import flash.display.BitmapData;
import flash.geom.Point;

import models.planet.MPlanetObject;
import models.tile.Tile;
import models.tile.TileKind;

import utils.Objects;
import utils.assets.AssetNames;
import utils.assets.ImagePreloader;


internal class MTilePlanetObject extends MPlanetObject
{

   public function MTilePlanetObject(tile: IRTileKindM) {
      Objects.paramNotNull("tile", tile);

      const IMG: ImagePreloader = ImagePreloader.getInstance();
      var tileTexture: BitmapData = null;
      if (tile.tileKind == TileKind.REGULAR) {
         tileTexture = IMG.getImage(
            AssetNames.getRegularTileImageName(tile.terrainType)
         );
      }
      else {
         tileTexture = IMG.getImage(
            AssetNames.getTileImageName(tile.tileKind)
         );
      }

      x = 0;
      y = 0;
      if (TileKind.isResourceKind(tile.tileKind)) {
         setSize(2, 2);
         _imageData = tileTexture;
      }
      else {
         setSize(1, 1);
         _imageData = new BitmapData(
            Tile.IMAGE_WIDTH, Tile.IMAGE_HEIGHT, true, 0x00000000
         );
         const tileMask:BitmapData = IMG.getImage(
            AssetNames.getTileMaskImageName(TileMaskType.TILE)
         );
         _imageData.copyPixels(
            tileTexture,
            tileMask.rect,
            new Point(0, 0),
            tileMask,
            new Point(0, 0)
         );
      }
   }


   private var _imageData: BitmapData = null;
   [Bindable(event="planetObjectImageChange")]
   public override function get imageData(): BitmapData {
      return _imageData;
   }
}
