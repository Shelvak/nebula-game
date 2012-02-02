package models.battle
{
   import flash.geom.Point;

   
   import spark.primitives.Rect;
   
   import utils.datastructures.RectSet;
   import utils.random.Rndm;
   
   public class PlaceFinder
   {
      private var random: Rndm;
      
      public var maxWidth: int;
      public var maxHeight: int;
      
      public function PlaceFinder(width: int, height: int, rand: Rndm)
      {
         random = rand;
         var firstRect: Rect = new Rect();
         firstRect.x = 0;
         firstRect.y = 0;
         firstRect.width = width;
         firstRect.height = height;
         maxWidth = width;
         maxHeight = height;
         rects.addItem(firstRect);
      }
      
      public var rects: RectSet = new RectSet();
      /**
       * array of failed rectangles as points (x -> width, y -> height) 
       */      
      private var failedRects: Array = [];
      
      public function findPlace(width: int, height: int, distinct: Boolean = false): Point
      {
         // check if object rect meets min requirements
         for each (var failedRect: Point in failedRects)
         {
            if (width >= failedRect.x && height >= failedRect.y)
            {
               if (distinct)
               {
                  return placeDistinct(width, height);
               }
               else
               {
                  return null;
               }
            }
         }
         
         // find the smallest size empty rect, which can accept this object rect
         var minEmptyRect: Rect = null;
         for each (var emptyRect: Rect in rects)
         {
            if (emptyRect.width >= width && emptyRect.height >= height)
            {
               if (
                  minEmptyRect == null 
                  || minEmptyRect.width * minEmptyRect.height > emptyRect.width * emptyRect.height
               )
               {
                  minEmptyRect = emptyRect;
               }
            }
         }
         // place object in empty rect if found and return its coordinates, else return null
         if (minEmptyRect != null)
         {
            return placeObject(width, height, minEmptyRect);
         }
         else
         {
            if (distinct)
            {
               return placeDistinct(width, height);
            }
            else
            {
               failedRects.push(new Point(width, height));
               return null;
            }
         }
      }
      
      private function placeObject(width: int, height: int, zone: Rect): Point
      {
         var objectRect: Rect = new Rect();
         objectRect.x = random.integer(zone.x, zone.x + (zone.width - width) + 1);
         objectRect.y = random.integer(zone.y, zone.y + (zone.height - height) + 1);
         objectRect.width = width;
         objectRect.height = height;
         splitAllThatCollidesWith(objectRect);
         return new Point(objectRect.x, objectRect.y);
      }
      
      private function placeDistinct(width: int, height: int): Point
      {
         var newFreeRect: Rect = new Rect();
         newFreeRect.x = maxWidth;
         newFreeRect.y = 0;
         newFreeRect.width = width;
         newFreeRect.height = maxHeight;
         maxWidth += width;
         rects.addItem(newFreeRect);
         var newFailedRects: Array = [];
         for each (var failedRect: Point in failedRects)
         {
            if (!(newFreeRect.width >= failedRect.x && newFreeRect.height >= failedRect.y))
            {
               newFailedRects.push(failedRect);
            }
         }
         failedRects = newFailedRects;
         return placeObject(width, height, newFreeRect);
      }
      
      private function splitAllThatCollidesWith(rect: Rect): void
      {
         var rectsToSplit: Array = [];
         for each (var emptyRect: Rect in rects)
         {
            if (collides(rect, emptyRect))
            {
               rectsToSplit.push(emptyRect);
            }
         }
         
         for each (var rectToSplit: Rect in rectsToSplit)
         {
            split(rectToSplit, rect);
         }
      }
      
      public function collides(source: Rect, target: Rect): Boolean
      {
         return (
            //check x coord collision
            (
               (source.x >= target.x && source.x < (target.x + target.width))
               || (target.x >= source.x && target.x < (source.x + source.width))
            )
            //check y coord collision
            && (
               (source.y >= target.y && source.y < (target.y + target.height))
               || (target.y >= source.y && target.y < (source.y + source.height))
            )
         );
      }
      
      public function split(rect: Rect, mask: Rect): void
      {
         rects.removeItem(rect);
         // LEFT
         if (mask.x > rect.x)
         {
            var leftRect: Rect = new Rect();
            leftRect.x = rect.x;
            leftRect.y = rect.y;
            leftRect.width = mask.x - rect.x;
            leftRect.height = rect.height;
            rects.addItem(leftRect);
         }
         // RIGHT
         if (mask.x + mask.width < rect.x + rect.width)
         {
            var rightRect: Rect = new Rect();
            rightRect.x = mask.x + mask.width;
            rightRect.y = rect.y;
            rightRect.width = rect.x + rect.width - (mask.x + mask.width);
            rightRect.height = rect.height;
            rects.addItem(rightRect);
         }
         // TOP
         if (mask.y > rect.y)
         {
            var topRect: Rect = new Rect();
            topRect.x = rect.x;
            topRect.y = rect.y;
            topRect.width = rect.width;
            topRect.height = mask.y - rect.y;
            rects.addItem(topRect);
         }
         // BOTTOM
         if (mask.y + mask.height < rect.y + rect.height)
         {
            var bottomRect: Rect = new Rect();
            bottomRect.x = rect.x;
            bottomRect.y = mask.y + mask.height;
            bottomRect.width = rect.width;
            bottomRect.height = rect.y + rect.height - (mask.y + mask.height);
            rects.addItem(bottomRect);
         }
      }
      
      public function getXStartFree(): int
      {
         for each (var emptyRect: Rect in rects)
         {
            if (emptyRect.height == maxHeight && emptyRect.x == 0)
               return emptyRect.width;
         }
         return 0;
      }
      
      public function getXEndFree(): int
      {
         for each (var emptyRect: Rect in rects)
         {
            if (emptyRect.height == maxHeight && (emptyRect.x + emptyRect.width == maxWidth))
               return emptyRect.width;
         }
         return 0;
      }
      /*
      public function freeEdge(newMinWidth: int): void
      {
      for each (var emptyRect: Rect in rects)
      {
      if (emptyRect.height == maxHeight && (emptyRect.x + emptyRect.width == maxWidth))
      {
      if (emptyRect.x < newMinWidth)
      {
      var leftRect: Rect = new Rect();
      leftRect.x = emptyRect.x;
      leftRect.y = emptyRect.y;
      leftRect.width = newMinWidth - emptyRect.x;
      leftRect.height = emptyRect.height;
      rects.addItem(leftRect);
      maxWidth -= (emptyRect.width - (newMinWidth - emptyRect.x));
      rects.removeItem(emptyRect);
      return;
      }
      maxWidth -= emptyRect.width;
      rects.removeItem(emptyRect);
      return;
      } 
      }
      }
      */
   }
}