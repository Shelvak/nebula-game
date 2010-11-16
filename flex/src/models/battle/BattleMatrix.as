package models.battle
{
   import flash.geom.Point;
   
   import mx.collections.ArrayCollection;

   /**
    * 
    * boolean matrix that represents battlefield participant objects 
    * false means there is an empty space
    * true means there is some object
    * 
    */
   public class BattleMatrix extends ArrayCollection
   {
      public static const FREE: int = 0;
      public static const TAKEN: int = -1;
      
      public var rowCount: int = 0;
      public var columnCount: int = 0;
      
      public function addColumn(): void
      {
         var column: ArrayCollection = new ArrayCollection(new Array(rowCount));
         for each (var element: int in column)
         element = FREE;
         addItemAt(column, columnCount);
         columnCount++;
      }
      
      public function isOccupied(point: Point): Boolean
      {
         return isOccupiedByCoords(point.x, point.y);
      }
      
      public function isOccupiedByCoords(x: int, y: int): Boolean
      {
         return getMeaning(x, y) != FREE;
      }
      
      /**
       * Checks if given space is free and creates column if there is no matrix in rightBottom
       * @param leftTop left top corner of battlefield space in cells
       * @param rightBottom right bottom corner of battlefield space in cells
       * @return true if given space is empty false otherwise
       * 
       */      
      public function isFree(leftTop: Point, rightBottom: Point): Boolean
      {
         while (columnCount < rightBottom.x + 1)
            addColumn();
         if (rightBottom.y >= rowCount || rightBottom.y < leftTop.y || leftTop.y < 0 || 
            leftTop.x < 0 || leftTop.x > rightBottom.x)
            return false;
         for (var i: int = leftTop.x; i<= rightBottom.x; i++)
            for (var j: int = leftTop.y; j<= rightBottom.y; j++)
               if (isOccupiedByCoords(i, j))
               {
                  return false;
               }
         return true;
      }
      
      public function occupyCell(x: int, y: int, meaning: int): void
      {
         try
         {
         (getItemAt(x) as ArrayCollection).setItemAt(meaning, y);
         }
         catch (err: RangeError)
         {
            throw new RangeError('rowCount: ' + rowCount + ' columnCount: ' + columnCount + ' x: ' + 
               x + ' y: ' + y + ' ' + err);
         }
      }
      
      public function freeCell(x: int, y: int): void
      {
         (getItemAt(x) as ArrayCollection).setItemAt(FREE, y);
      }
      
      private function getMeaning(x:int, y:int): int
      {
         try {
            return int((getItemAt(x) as ArrayCollection).getItemAt(y));
         } 
         catch (err:Error){
            throw new Error('Column count: ' + columnCount + ' row count: ' + rowCount + ' x: ' + x + ' y: ' + y);
         }
         return 0;
      }
      
      /**
       * moves given space of imaginary object by step horizontaly,
       * step is possitive if moving to the right, negative otherwise  
       * @param leftTop left top corner of battlefield space in cells
       * @param rightBottom right bottom corner of battlefield space in cells
       */    
      public function move(leftTop: Point, rightBottom: Point, step: int): void
      {
         free(leftTop, rightBottom);
         occupy(new Point(leftTop.x + step, leftTop.y), 
            new Point(rightBottom.x + step, rightBottom.y));
      }
      
      /**
       * frees given space  
       * @param leftTop left top corner of battlefield space in cells
       * @param rightBottom right bottom corner of battlefield space in cells
       */      
      public function free(leftTop: Point, rightBottom: Point): void
      {
         for (var i: int = leftTop.x; i<= rightBottom.x; i++)
            for (var j: int = leftTop.y; j<= rightBottom.y; j++)
               freeCell(i, j);
      }
      
      /**
       * occupies given space  
       * @param leftTop left top corner of battlefield space in cells
       * @param rightBottom right bottom corner of battlefield space in cells
       */      
      public function occupy(leftTop: Point, rightBottom: Point): void
      {
         for (var i: int = leftTop.x; i<= rightBottom.x; i++)
            for (var j: int = leftTop.y; j<= rightBottom.y; j++)
               occupyCell(i, j, TAKEN);
      }
      
      public function returnTestMatrix(): Array
      {
         var matrix: Array = new Array();
         for (var i: int = 0; i<rowCount; i++)
         {
            matrix.push(new Array());
            for (var j: int = 0; j<columnCount; j++)
               (matrix[i] as Array).push(getMeaning(j, i));
         }
         return matrix;
      }
      
      public function getFreeHorizontalCols(leftTop: Point, rightBottom: Point, direction: int): int
      {
         var freeCols: int = 0;
         if (direction == 0)
         {
            for (var i: int = leftTop.x; i<= rightBottom.x; i++)
            {
               for (var j: int = leftTop.y; j<= rightBottom.y; j++)
               {
                  if ((isOccupied(new Point(i, j))) || (isOccupied(new Point(i, 0))))
                  {
                     return freeCols;
                  }
                  
               }
               freeCols++;
            }
         }
         else
         {
            for (i = rightBottom.x; i>= leftTop.x; i--)
            {
               for (j = leftTop.y; j<= rightBottom.y; j++)
                  if ((isOccupied(new Point(i, j)))|| (isOccupied(new Point(i, 0))))
                  {
                     return freeCols;
                  }
               freeCols++;
            } 
         }
         return freeCols;
      }
   }
}