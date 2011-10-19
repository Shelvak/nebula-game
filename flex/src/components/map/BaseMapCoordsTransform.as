package components.map
{
   import flash.geom.Point;
   
   import utils.Objects;
   
   
   /**
    * Base abstract implementation of <code>IMapCoordsTransform</code>.
    * <p>Implemented properties:
    * <ul><code>
    *    <li>logicalWidth</li>
    *    <li>logicalHeight</li>
    * </code></ul>
    * </p>
    * <p>Implemented methods:
    * <ul><code>
    *    <li>logicalToReal()</li>
    *    <li>realToLogical()</li>
    * </code></ul>
    * </p> 
    */
   public class BaseMapCoordsTransform implements IMapCoordsTransform
   {
      private var _logicalWidth:int;
      public function set logicalWidth(value:int) : void {
         if (_logicalWidth != value) {
            _logicalWidth = value;
         }
      }
      public function get logicalWidth() : int {
         return _logicalWidth;
      }
      
      private var _logicalHeight:int;
      public function set logicalHeight(value:int) : void {
         if (_logicalHeight != value) {
            _logicalHeight = value;
         }
      }
      public function get logicalHeight() : int {
         return _logicalHeight;
      }
      
      public function logicalToReal(logical:Point) : Point {
         return new Point(
            logicalToReal_X(logical.x, logical.y),
            logicalToReal_Y(logical.x, logical.y)
         );
      }
      
      public function realToLogical(real:Point) : Point {
         return new Point(
            realToLogical_X(real.x, real.y),
            realToLogical_Y(real.x, real.y)
         );
      }
      
      
      /* ######################## */
      /* ### ABSTRACT MEMBERS ### */
      /* ######################## */
      
      public function get realWidth() : Number {
         Objects.throwAbstractPropertyError();
         return 0;   // unreachable
      }
      
      public function get realHeight() : Number {
         Objects.throwAbstractPropertyError();
         return 0;   // unreachable
      }
      
      public function logicalToReal_X(logicalX:int, logicalY:int) : Number {
         Objects.throwAbstractMethodErrror();
         return 0;   // unreachable
      }
      
      public function logicalToReal_Y(logicalX:int, logicalY:int) : Number {
         Objects.throwAbstractMethodErrror();
         return 0;   // unreachable
      }
      
      public function realToLogical_X(realX:Number, realY:Number) : int {
         Objects.throwAbstractMethodErrror();
         return 0;   // unreachable
      }
      
      public function realToLogical_Y(realX:Number, realY:Number) : int {
         Objects.throwAbstractMethodErrror();
         return 0;   // unreachable
      }
   }
}