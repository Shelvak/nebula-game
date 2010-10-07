package components.map.space
{
   import components.gameobjects.solarsystem.SolarSystemTile;
   
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;

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
         _graphics.clear();
         _graphics.lineStyle(2, 0x00FF00);
         for each (var element:BorderElement in _borders)
         {
            var coords:Point = _grid.getSectorRealCoordinates(element.location);
            
            var xFrom:Number, yFrom:Number, xTo:Number, yTo:Number;
            function line() : void
            {
               _graphics.moveTo(xFrom, yFrom);
               _graphics.lineTo(xTo, yTo);
            }
            if (element.left || element.right)
            {
               yFrom = coords.y - SolarSystemTile.HEIGHT / 2;
               yTo = coords.y + SolarSystemTile.HEIGHT / 2;
               if (element.left)
               {
                  xFrom = xTo = coords.x - SolarSystemTile.WIDTH / 2; line();
               }
               if (element.right)
               {
                  xFrom = xTo = coords.x + SolarSystemTile.WIDTH / 2; line();
               }
            }
            if (element.top || element.bottom)
            {
               yFrom = yTo = coords.y + SolarSystemTile.HEIGHT / 2 * (element.top ? -1 : 1);
               xFrom = coords.x - SolarSystemTile.WIDTH / 2;
               xTo = coords.x + SolarSystemTile.WIDTH / 2;
               if (element.top)
               {
                  yFrom = yTo = coords.y - SolarSystemTile.HEIGHT / 2; line();
               }
               if (element.bottom)
               {
                  yFrom = yTo = coords.y + SolarSystemTile.HEIGHT / 2; line();
               }
            }
         }
      }
      
      
      private var _borders:Vector.<BorderElement>;
      private function buildBordersList() : void
      {
         _borders = new Vector.<BorderElement>();
         var bounds:Rectangle = _galaxy.bounds;
         var matrix:Vector.<Vector.<Boolean>> = _galaxy.fowMatrix;
         // since models.galaxy.FOWMatrixBuilder added tow additional rows and columns in the
         // edges of the matrix, we work with the inner rectangle. Without those additional columns
         // and rows we would have to run boundary checks in each iteration
         for (var x:int = bounds.left + 1; x < bounds.right; x++)
         {
            var xx:int = x + _galaxy.offset.x;
            for (var y:int = bounds.top + 1; y < bounds.bottom; y++)
            {
               var yy:int = y + _galaxy.offset.y;
               if (matrix[xx][yy] && (!matrix[xx - 1][yy] || !matrix[xx + 1][yy] ||
                                      !matrix[xx][yy - 1] || !matrix[xx][yy + 1]))
               {
                  _borders.push(new BorderElement(
                     getLocation(x, y),
                     !matrix[xx - 1][yy], !matrix[xx + 1][yy],
                     !matrix[xx][yy - 1], !matrix[xx][yy + 1]
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