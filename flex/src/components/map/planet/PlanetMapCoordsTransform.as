package components.map.planet
{
   import components.map.IMapCoordsTransform;
   
   import flash.geom.Point;
   
   public class PlanetMapCoordsTransform implements IMapCoordsTransform
   {
      /**
       * @param logicalWidth logical width of a planet map
       * @param logicalHeight logical height of a planet map
       * @param borderSize width of a border around the actual planet map (number of tiles)
       */
      public function PlanetMapCoordsTransform(logicalWidth:int = 0,
                                               logicalHeight:int = 0,
                                               borderSize:int = 0)
      {
         super();
         _logicalWidth  = logicalWidth;
         _logicalHeight = logicalHeight;
      }
      
      
      private var _borderSize:int = 0;
      /**
       * Width of a border (number of tiles) around the actual planet map. Positive integer, icluding 0.
       */
      public function set borderSize(value:int) : void
      {
         if (value < 0)
         {
            throw new ArgumentError("Positive integer expected: was " + value);
         }
         _borderSize = value;
      }
      /**
       * @private
       */
      public function get borderSize() : int
      {
         return _borderSize;
      }
      
      
      private var _logicalWidth:int = 0;
      public function set logicalWidth(value:int) : void
      {
         _logicalWidth = value;
      }
      public function get logicalWidth():int
      {
         return 0;
      }
      
      
      private var _logicalHeight:int = 0;
      public function set logicalHeight(value:int) : void
      {
         _logicalHeight = value;
      }
      public function get logicalHeight() : int
      {
         return _logicalHeight;
      }
      
      
      public function get realWidth() : Number
      {
         return 0;
      }
      
      
      public function get realHeight() : Number
      {
         return 0;
      }
      
      
      public function logicalToReal(logical:Point) : Point
      {
         return null;
      }
      
      
      public function logicalToReal_X(logicalX:int, logicalY:int) : Number
      {
         return 0;
      }
      
      
      public function logicalToReal_Y(logicalX:int, logicalY:int) : Number
      {
         return 0;
      }
      
      
      public function realToLogical(real:Point) : Point
      {
         return null;
      }
      
      
      public function realToLogical_X(realX:Number, realY:Number) : int
      {
         return 0;
      }
      
      
      public function realToLogical_Y(realX:Number, realY:Number) : int
      {
         return 0;
      }
   }
}