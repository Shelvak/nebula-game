package components.map.space.galaxy.entiregalaxy
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.galaxy.FOWBorderElement;
   import models.galaxy.FOWMatrix;
   import models.galaxy.MEntireGalaxy;
   
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   public final class EntireGalaxyRenderer
   {
      public static const SECTOR_SIZE: uint = 12;   // pixels
      public static const GAP_SIZE: uint = 4;       // pixels

      private var _solarSystems: Array;
      private var _fowMatrix: FOWMatrix;
      private var _coordsTransform: CoordsTransform;

      public function EntireGalaxyRenderer(galaxy: MEntireGalaxy) {
         Objects.paramNotNull("galaxy", galaxy);
         _solarSystems = galaxy.solarSystems;
         _fowMatrix = galaxy.fowMatrix;

         _coordsTransform = new CoordsTransform(_fowMatrix.getCoordsOffset());
         _coordsTransform.logicalWidth = _fowMatrix.getBounds().width;
         _coordsTransform.logicalHeight = _fowMatrix.getBounds().height;

         render();
      }

      private var _bitmap: BitmapData;
      public function get bitmap(): BitmapData {
         return _bitmap;
      }

      private function render(): BitmapData {
         if (_bitmap == null) {
            _bitmap = new BitmapData(
               _coordsTransform.realWidth, _coordsTransform.realHeight, true, uint(0));
            for each (var ss: MiniSS in _solarSystems) {
               putSolarSystem(ss);
            }
            for each (var borderElem: FOWBorderElement in _fowMatrix.getFOWBorderList()) {
               putBorder(borderElem);
            }
         }
         return _bitmap;
      }

      private function putSolarSystem(ss: MiniSS): void {
         const x: int = ss.x;
         const y: int = ss.y;
         const image: BitmapData = getImage(ss.type); 
         _bitmap.copyPixels(
            image, image.rect, _coordsTransform.logicalToReal(new Point(x, y)), null, null, true);
      }

      private function putBorder(element: FOWBorderElement): void {
         const color: uint = Colors.BORDER_COLOR;
         const x: int = element.location.x;
         const y: int = element.location.y;
         var px: int = _coordsTransform.logicalToReal_X(x, y);
         var py: int = _coordsTransform.logicalToReal_Y(x, y);

         function fill(x: int, y: int, width: int, height: int): void {
            _bitmap.fillRect(new Rectangle(x, y, width, height), color);
         }

         if (element.left || element.right) {
            px += element.left
               ? - GAP_SIZE
               : + SECTOR_SIZE;
            fill(px, py - GAP_SIZE,    GAP_SIZE, GAP_SIZE);
            fill(px, py,               GAP_SIZE, SECTOR_SIZE);
            fill(px, py + SECTOR_SIZE, GAP_SIZE, GAP_SIZE);
         }
         else if (element.top || element.bottom) {
            py += element.top
               ? - GAP_SIZE
               : + SECTOR_SIZE;
            fill(px - GAP_SIZE,    py, GAP_SIZE,    GAP_SIZE);
            fill(px,               py, SECTOR_SIZE, GAP_SIZE);
            fill(px + SECTOR_SIZE, py, GAP_SIZE,    GAP_SIZE);
         }
      }
      
      private function getImage(ssType: String): BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.getMiniSSIconImageName(ssType));
      }
   }
}