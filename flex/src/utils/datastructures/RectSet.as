package utils.datastructures
{
   import flash.utils.Proxy;
   
   import spark.primitives.Rect;

   public class RectSet extends Set
   {
      public function RectSet()
      {
         super (
            function (rect: Rect): String
            {
               return rect.x + ',' + rect.y + ',' + rect.width + ',' + rect.height;
            }
            );
      }
   }
}