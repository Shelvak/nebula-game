package utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   public class BitmapUtil
   {
      public static function flipHorizontally(source:BitmapData) : BitmapData
      {
         var result: BitmapData = new BitmapData(source.width, source.height);
         for (var x:int = source.width - 1; x >= 0 ; x--)
         {
            for (var y:int = 0; y < source.height; y++)
            {
               result.setPixel32(source.width - x - 1, y, source.getPixel32(x, y));
            }
         }
         return result;
      }


      public static function flipVertically(source:BitmapData) : BitmapData
      {
         var result:BitmapData = new BitmapData(source.width, source.height);
         for (var x:int = 0; x < source.width; x++)
         {
            for (var y:int = source.height - 1; y >= 0; y--)
            {
               result.setPixel32(x, source.height - y - 1, source.getPixel32(x, y));
            }
         }
         return result;
      }


      /**
       * This method will fill target area of target bitmap with pixels from source bitmap. If source bitmap is
       * smaller that the target area this method will fill target bitmap like <code>BitmapImage</code> fills
       * its whole are in such case when <code>BitmapImage.fillMode = BitmapFillMode.REPEAT</code>.
       *
       * @param source source bitmap containing pixels to fill target with
       * @param target target bitmap image to fill
       * @param targetRect area of target bitmap to fill. If not provided, whole area of target bitmap is filled
       * @param mergeAlpha if <code>true</code> alpha cannel will be also used during this operation.
       * See <code>BitmapData.copyPixels()</code> for more information about this parameter.
       *
       * @see BitmapData#copyPixels()
       */
      public static function fillWithBitmap(source:BitmapData,
                                            target:BitmapData,
                                            targetRect:Rectangle = null,
                                            mergeAlpha:Boolean = false) : void
      {
         // We have to fill whole target bitmap if targetArea has not been provided
         if (targetRect == null)
         {
            targetRect = target.rect;
         }

         var sourceRect:Rectangle = source.rect;
         var targetPoint:Point = targetRect.topLeft.clone();
         while (targetPoint.x < targetRect.width + targetRect.x)
         {
            while (targetPoint.y < targetRect.height + targetRect.y)
            {
               target.copyPixels(source, source.rect, targetPoint, null, null, mergeAlpha);
               targetPoint.y += source.height;
            }

            targetPoint.x += source.width;
            targetPoint.y  = targetRect.y;
         }
      }
   }
}