package utils
{
   import flash.geom.Rectangle;
   
   
   /**
    * Utility class for working with geometry.
    */
   public final class GeomUtils
   {
      /**
       * Subtract <code>toSubtract</code> rectangle from <code>target</code>.
       * 
       * @param target rectangle to subtract <code>toSubtract</code> from
       * <ul><b>
       *    <li>not null</li>
       *    <li>zero or positive <code>width</code> and <code>height</code></li>
       * </b></ul>
       * 
       * @param toSubtract rectangle to subtract from <code>target</code>
       * <ul><b>
       *    <li>not null</li>
       *    <li>zero or positive <code>width</code> and <code>height</code></li>
       * </b></ul>
       * 
       * @return array of <code>SubtractionRectangle</code>s (0 at minimum and
       * 4 at most) that were created after this operation. Suppose the outer
       * rectangle is the target and the inner is a rectangle being subtracted:
       * <pre>
       * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TARGET
       * ----------------
       * |...|..2...|...|
       * |...|......|...|
       * |...|------|...|
       * |.0.| SUBT |.1.|
       * |...| RACT |...|
       * |...|------|...|
       * |...|......|...|
       * |...|..3...|...|
       * ----------------
       * </pre>
       * The result will be four rectangles shown in the picture above and the
       * number inside them define indices of the rectangles in resulting array.
       * In case any of the four rectangles end up with a zero-area, that
       * rectangle is not included in the resulting array. For example:
       * <pre>
       * &nbsp;&nbsp;&nbsp;TARGET
       * ------------
       * |..1...|...|
       * |......|...|
       * |------|...|
       * | SUBT |.0.|
       * | RACT |...|
       * |------|...|
       * |......|...|
       * |..2...|...|
       * ------------
       * </pre>
       * So the result of the above operation is an array of three rectangles:
       * 0, 1 and 2.
       * 
       * <p>If <code>target</code> is a zero-area rectangle, empty array is
       * returned. If that is not the case but <code>toSubtract</code> defines
       * a zero-area rectangle, clone of the target is returned .</p>
       * 
       * <p>If subtraction operation does not produce any of the four
       * rectangles (that means rectangle being subtracted fully covers the
       * target), a zero length array is returned.</p>
       * 
       * <p>Similarly, if the two rectangles do not intersect, the clone of
       * the <code>target</code> is the only element of the array returned.</p>
       */
      public static function subtract(target:Rectangle,
                                      toSubtract:Rectangle) : Vector.<Rectangle> {
         Objects.paramNotNull("target", target);
         Objects.paramNotNull("toSubtract", toSubtract);
         nonNegativeArea("target", target);
         nonNegativeArea("toSubtract", toSubtract);
         
         var sections:Vector.<Rectangle> = new Vector.<Rectangle>();
         if (voidArea(target)) {
            return sections;
         }
         if (voidArea(toSubtract)) {
            sections.push(target.clone());
            return sections;
         }
         var intersection:Rectangle = target.intersection(toSubtract);
         // if no intersection, the result of operation is the subject area (this) itself
         if (voidArea(intersection)) {
            sections.push(target.clone());
            return sections;
         }
         
         // left
         //  --------------
         // |###|      |   |
         // |###|      |   |
         // |#P#|------|   |
         // |#U#| INTR |   |
         // |#S#| SECT |   |
         // |#H#|------|   |
         // |###|      |   |
         // |###|      |   |
         //  --------------
         if (target.x != intersection.x) {
            sections.push(new Rectangle(
               target.x, target.y,
               intersection.x - target.x, target.height
            ));
         }
         
         // right
         //  --------------
         // |   |      |###|
         // |   |      |###|
         // |   |------|#P#|
         // |   | INTR |#U#|
         // |   | SECT |#S#|
         // |   |------|#H#|
         // |   |      |###|
         // |   |      |###|
         //  --------------
         if (target.right != intersection.right) {
            sections.push(new Rectangle(
               intersection.right, target.y,
               target.right - intersection.right, target.height
            ));
         }
         
         // top
         //  --------------
         // |   |#PUSH#|   |
         // |   |######|   |
         // |   |------|   |
         // |   | INTR |   |
         // |   | SECT |   |
         // |   |------|   |
         // |   |      |   |
         // |   |      |   |
         //  --------------
         if (target.y != intersection.y) {
            sections.push(new Rectangle(
               intersection.x, target.y,
               intersection.width, intersection.y - target.y
            ));
         }
         
         // bottom
         //  --------------
         // |   |      |   |
         // |   |      |   |
         // |   |------|   |
         // |   | INTR |   |
         // |   | SECT |   |
         // |   |------|   |
         // |   |#PUSH#|   |
         // |   |######|   |
         //  --------------
         if (target.bottom != intersection.bottom) {
            sections.push(new Rectangle(
               intersection.x, intersection.bottom,
               intersection.width, target.bottom - intersection.bottom
            ));
         }
         
         return sections;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private static function nonNegativeArea(paramName:String,
                                              paramValue:Rectangle) : void {
         if (paramValue.width < 0 || paramValue.height < 0) {
            throw new ArgumentError(StringUtil.substitute(
               "[param {0}] must have a non-negative area but was {1}",
               paramName, paramValue
            ));
         }
      }
      
      private static function voidArea(rectangle:Rectangle) : Boolean {
         return rectangle.width == 0 || rectangle.height == 0;
      }
   }
}