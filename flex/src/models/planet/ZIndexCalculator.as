package models.planet
{
   

   /**
    * This class takes am most O(w*h) time to recalculate <code>zIndex</code> value of all objects
    * on the map where <code>w</code> is logical width of the map and <code>h</code> is logical
    * height of the map in tiles.
    */
   public class ZIndexCalculator
   {
      private var currentZIndex:int;
      private var map:Planet;
      private var visitedFlags:Array;
      /**
       * Creates instance of <code>ZIndexCalculator</code> and binds the given <code>Planet</code>
       * to it. Does not recalculate <code>zIndex</code> values. You should call
       * <code>reacalculate()</code> each time you need to update <code>zIndex</code> values of
       * map objects.
       * 
       * @param map A map which contains objects that need to have <code>zIndex</code>
       * property recalculated.
       * 
       * @throws Error if <code>map</code> is <code>null</code>
       */
      public function ZIndexCalculator(map:Planet)
      {
         if (map == null)
         {
            throw new Error("map must be a valid instance of Map");
         }
         this.map = map;
      }
      
      
      /**
       * Recalculates <code>zIndex</code> value for each object on the planet. You can call this method
       * as many times as you want however bare in mind that this operation might be expensive in terms
       * of performance, espacially for large maps.
       */
      public function calculateZIndex() : void
      {
         // Don't do anything if planet has no map
         if (map.width == 0 || map.height == 0)
         {
            return;
         }
         
         // Each time clear flags array and reset currentZIndex
         currentZIndex = 0;
         visitedFlags = [];
         for (var x:int = 0; x < map.width; x++)
         {
            var row:Array = [];
            for (var y:int = 0; y < map.height; y++)
            {
               row.push(false);
            }
            visitedFlags.push(row);
         }
         
         // Start form the most distant corner
         walkBlock(new BlockCoords(0, map.width - 1, map.height - 1, 0));
      }
      
      
      private function splitBlock(object:PlanetObject, currentBlock:BlockCoords) : void
      {
         // Top block (above object)
         walkBlock(new BlockCoords(object.x, object.xEnd - 1, map.height - 1, object.yEnd + 1));
         // Area under object itself
         setObjectZIndex(object);
         visitArea(object);
         // Bottom block (below object)
         walkBlock(new BlockCoords(object.x, object.xEnd, object.y - 1, currentBlock.bottom))
      }
      
      
      // Travelling from top to bottom then form right to left
      private function walkBlock(block:BlockCoords) : void
      {
         var x:int = block.right;
         var y:int = block.top + 1;
         
         // Bounds check
         if (block.top < block.bottom ||
             y > map.height + 1 || y < block.bottom)
         {
            return;
         }
         
         while (x > block.left || y > block.bottom)
         {
            if (y == block.bottom)
            {
               y = block.top;
               x--;
            }
            else
            {
               y--;
            }
            
            // Just skip this position if it has already been visited
            if (visitedFlags[x][y])
            {
               continue;
            }
            
            // Split the walk if we need
            var object:PlanetObject = map.getObject(x, y);
            if (object && object.width > 1)
            {
               splitBlock(object, block);
               x = object.x;
               y = block.bottom;
            }
            else if (object)
            {
               setObjectZIndex(object);
               visitArea(object);
            }
            else
            {
               visitPosition(x, y);
            }
         }
      }
      
      
      private function setObjectZIndex(object:PlanetObject) : void
      {
         object.zIndex = currentZIndex++;
      }
      
      
      private function visitArea(object:PlanetObject) : void
      {
         for (var x:int = object.x; x <= object.xEnd; x++)
         {
            for (var y:int = object.y; y <= object.yEnd; y++)
            {
               visitPosition(x, y);
            }
         }
      }
      
      
      private function visitPosition(x:int, y:int) : void
      {
         visitedFlags[x][y] = true;
      }
   }
}


class BlockCoords
{
   public var left:int = 0;
   public var right:int = 0;
   public var top:int = 0;
   public var bottom:int = 0;
   
   
   public function BlockCoords(left:int, right:int, top:int, bottom:int)
   {
      this.left = left;
      this.right = right;
      this.top = top;
      this.bottom = bottom;
   }
}