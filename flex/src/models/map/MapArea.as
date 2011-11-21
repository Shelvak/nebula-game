package models.map
{
   import flash.geom.Rectangle;
   
   import interfaces.IEqualsComparable;
   
   import mx.utils.StringUtil;
   
   import utils.GeomUtils;
   import utils.Objects;
   
   
   /**
    * Defines rectangular area of map in logical coordinates:
    * <ul>
    *    <li>2D Cartesian coordinate system</li>
    *    <li>coordinates are integers</li>
    * </ul>
    */
   public class MapArea implements IEqualsComparable
   {
      /**
       * Creates new instance of <code>MapArea</code> form given <code>Rectangle</code>.
       * 
       * @param rectangle | <b>not null</b>
       */
      public static function createFromRectangle(rectangle:Rectangle) : MapArea {
         Objects.paramNotNull("rectangle", Rectangle);
         return new MapArea(
            rectangle.x, getXMax(rectangle),
            rectangle.y, getYMax(rectangle)
         );
      }
      
      
      /* ###################### */
      /* ### STATIC HELPERS ### */
      /* ###################### */
      
      private static function getXMax(rect:Rectangle) : int {
         return rect.right - 1;
      }
      
      private static function getYMax(rect:Rectangle) : int {
         return rect.bottom - 1;
      }
      
      
      /* ################ */
      /* ### INSTANCE ### */
      /* ################ */
      
      private const _rect:Rectangle = new Rectangle();
      
      /**
       * @param xMin | <b>&lt;= <code>xMax</code></b>
       * @param xMax | <b>&gt;= <code>xMin</code></b>
       * @param yMin | <b>&gt;= <code>yMax</code></b>
       * @param yMax | <b>&gt;= <code>yMin</code></b>
       */
      public function MapArea(xMin:int, xMax:int, yMin:int, yMax:int) {
         validateRange(xMin, "xMin", xMax, "xMax");
         validateRange(yMin, "yMin", yMax, "yMax");
         _rect.x = xMin;
         _rect.y = yMin;
         _rect.width = getEdgeLength(xMin, xMax);
         _rect.height = getEdgeLength(yMin, yMax);
      }
      
      public function get xMin() : int {
         return _rect.x;
      }
      
      public function get xMax() : int {
         return getXMax(_rect);
      }
      
      /**
       * Sets <code>xMin</code> and <code>xMax</code> properties to <code>min</code>
       * and <code>max</code> respectively.
       * 
       * @param min | <b>&lt;= <code>max</code></b>
       * @param max | <b>&gt;= <code>min</code></b>
       */
      public function setX(min:int, max:int) : void {
         validateRange(min, "min", max, "max");
         _rect.x = min;
         _rect.width = getEdgeLength(min, max);
      }
      
      public function get yMin() : int {
         return _rect.y;
      }
      
      public function get yMax() : int {
         return getYMax(_rect);
      }
      
      /**
       * Sets <code>yMin</code> and <code>yMax</code> properties to <code>min</code>
       * and <code>max</code> respectively.
       * 
       * @param min | <b>&lt;= <code>max</code></b>
       * @param max | <b>&gt;= <code>min</code></b>
       */
      public function setY(min:int, max:int) : void {
         validateRange(min, "min", max, "max");
         _rect.y = min;
         _rect.height = getEdgeLength(min, max);
      }
      
      public function get width() : int {
         return _rect.width;
      }
      
      public function get height() : int {
         return _rect.height;
      }
      
      public function union(toUnion:MapArea) : MapArea {
         Objects.paramNotNull("toUnion", toUnion);
         return createFromRectangle(this._rect.union(toUnion._rect));
      }
      
      public function substract(toSubstract:MapArea) : Vector.<MapArea> {
         Objects.paramNotNull("toSubstract", toSubstract);
         var sections:Vector.<MapArea> = new Vector.<MapArea>();
         for each (var section:Rectangle in GeomUtils.subtract(this._rect, toSubstract._rect)) {
            sections.push(MapArea.createFromRectangle(section));
         }
         return sections;
      }
      
      public function clone() : MapArea {
         return new MapArea(xMin, xMax, yMin, yMax);
      }
      
      public function contains(x:int, y:int) : Boolean {
         return xMin <= x && x <= xMax
             && yMin <= y && y <= yMax;
      }
      
      public function toString() : String {
         return "[class:" + Objects.getClassName(this)
            + ", xMin: " + xMin
            + ", xMax: " + xMax
            + ", yMin: " + yMin
            + ", yMax: " + yMax
            + ", w: " + width
            + ", h: " + height + "]";
      }
      
      
      /* ######################### */
      /* ### IEqualsComparable ### */
      /* ######################### */
      
      public function equals(o:Object) : Boolean {
         if (o == null || !(o is MapArea)) {
            return false;
         }
         return this._rect.equals(MapArea(o)._rect);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getEdgeLength(min:int, max:int) : int {
         return max - min + 1;
      }
      
      private function validateRange(min:int, minName:String,
                                     max:int, maxName:String) : void {
         if (min > max) {
            StringUtil.substitute(
               "[param {0}] must be less that [param {1}] but"
               + "\n   [param {0}] was equal to {2}"
               + "\n   [param {1}] was equal to {3}",
               minName, maxName, min, max
            );
         }
      }
   }
}