package components.map.space.galaxy
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;

   import models.galaxy.FOWBorderElement;
   import models.galaxy.Galaxy;

   import utils.MathUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;


   internal class FOWRenderer
   {
      private var _galaxy:Galaxy;
      private var _grid:GridGalaxy;
      private var _graphics:Graphics;


      public function FOWRenderer(galaxy: Galaxy, grid: GridGalaxy, graphics: Graphics) {
         _galaxy = galaxy;
         _grid = grid;
         _graphics = graphics;
      }

      public function redraw() : void {
         drawBorders();
      }

      private function drawBorders() : void {
         var fowLine: BitmapData = ImagePreloader.getInstance().getImage(AssetNames.FOW_LINE);
         var matrixRight: Matrix = new Matrix();
         matrixRight.scale(
            GridGalaxy.SECTOR_WIDTH / fowLine.width,
            GridGalaxy.SECTOR_HEIGHT / fowLine.height);
         var matrixLeft:Matrix = matrixRight.clone();
         matrixLeft.rotate(MathUtil.degreesToRadians(180));
         var matrixTop:Matrix = matrixRight.clone();
         matrixTop.rotate(MathUtil.degreesToRadians(-90));
         var matrixBottom:Matrix = matrixRight.clone();
         matrixBottom.rotate(MathUtil.degreesToRadians(90));
         _graphics.clear();
         for each (var element:FOWBorderElement in _galaxy.fowBorders) {
            var coords: Point = _grid.getSectorRealCoordinates(element.location);
            var x: Number = coords.x - GridGalaxy.SECTOR_WIDTH / 2;
            var y: Number = coords.y - GridGalaxy.SECTOR_HEIGHT / 2;
            function line(matrix: Matrix): void {
               _graphics.beginBitmapFill(fowLine, matrix);
               _graphics.drawRect(x, y, GridGalaxy.SECTOR_WIDTH, GridGalaxy.SECTOR_HEIGHT);
               _graphics.endFill();
            }
            if (element.left) line(matrixLeft);
            if (element.right) line(matrixRight);
            if (element.top) line(matrixTop);
            if (element.bottom) line(matrixBottom);
         }
      }
   }
}