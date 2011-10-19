package components.map.space
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapArea;
   
   import utils.MathUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;

   internal class FOWRenderer
   {
      private var _galaxy:Galaxy;
      private var _grid:GridGalaxy;
      private var _graphics:Graphics;
      
      
      public function FOWRenderer(galaxy:Galaxy, grid:GridGalaxy, graphics:Graphics)
      {
         _galaxy = galaxy;
         _grid = grid;
         _graphics = graphics;
      }
      
      
      public function redraw() : void
      {
         buildBordersList();
         drawBorders();
         _borders = null;
      }
      
      
      private function drawBorders() : void
      {
         var fowLine:BitmapData = ImagePreloader.getInstance().getImage(AssetNames.FOW_LINE);
         var matrixRight:Matrix = new Matrix();
         matrixRight.scale(GridGalaxy.SECTOR_WIDTH / fowLine.width,
                           GridGalaxy.SECTOR_HEIGHT / fowLine.height);
         var matrixLeft:Matrix = matrixRight.clone();
         matrixLeft.rotate(MathUtil.degreesToRadians(180));
         var matrixTop:Matrix = matrixRight.clone();
         matrixTop.rotate(MathUtil.degreesToRadians(90));
         var matrixBottom:Matrix = matrixRight.clone();
         matrixBottom.rotate(MathUtil.degreesToRadians(-90));
         _graphics.clear();
         for each (var element:BorderElement in _borders)
         {
            var coords:Point = _grid.getSectorRealCoordinates(element.location);
            var x:Number = coords.x - GridGalaxy.SECTOR_WIDTH / 2,
                y:Number = coords.y - GridGalaxy.SECTOR_HEIGHT / 2;
            function line(matrix:Matrix) : void
            {
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
      
      
      private var _borders:Vector.<BorderElement>;
      private function buildBordersList() : void
      {
         _borders = new Vector.<BorderElement>();
         var bounds:MapArea = _galaxy.bounds;
         var matrix:Vector.<Vector.<Boolean>> = _galaxy.fowMatrix;
         // since models.galaxy.FOWMatrixBuilder added two additional rows and columns in the
         // edges of the matrix, we work with the inner rectangle. Without those additional columns
         // and rows we would have to run boundary checks in each iteration
         for (var x:int = bounds.xMin + 1; x <= bounds.xMax - 1; x++)
         {
            var xx:int = x + _galaxy.offset.x;
            for (var y:int = bounds.yMin + 1; y <= bounds.yMax - 1; y++)
            {
               var yy:int = y + _galaxy.offset.y;
               if (!matrix[xx][yy] && (matrix[xx - 1][yy] || matrix[xx + 1][yy] ||
                                       matrix[xx][yy - 1] || matrix[xx][yy + 1]))
               {
                  _borders.push(new BorderElement(
                     getLocation(x, y),
                     matrix[xx - 1][yy], matrix[xx + 1][yy],
                     matrix[xx][yy - 1], matrix[xx][yy + 1]
                  ));
               }
            }
         }
      }
      
      
      private function getLocation(x:int, y:int) : LocationMinimal
      {
         var loc:LocationMinimal = new LocationMinimal();
         loc.type = LocationType.GALAXY;
         loc.x = x;
         loc.y = y;
         return loc;
      }
   }
}


import models.location.LocationMinimal;
internal class BorderElement
{
   public function BorderElement(location:LocationMinimal,
                                 left:Boolean = false, right:Boolean = false,
                                 top:Boolean = false, bottom:Boolean = false)
   {
      this.location = location;
      this.left = left;
      this.right = right;
      this.top = top;
      this.bottom = bottom;
   }
   public var location:LocationMinimal,
              left:Boolean, right:Boolean,
              top:Boolean, bottom:Boolean;
}