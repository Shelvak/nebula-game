package components.map
{
   import flash.geom.Point;

   /**
    * Defines methods and properties of an object reponsible for transforming logical map coordinates
    * to real coordinates and vise-versa.
    */
   public interface IMapCoordsTransform
   {
      /**
       * Logical width of a map. Positive integer, including 0. Default - 0.
       */
      function set logicalWidth(value:int) : void;
      /**
       * @private
       */
      function get logicalWidth() : int;
      
      
      /**
       * Logical height of a map. Positive integer, including 0. Default - 0.
       */
      function set logicalHeight(value:int) : void;
      /**
       * @private
       */
      function get logicalHeight() : int;
      
      
      /**
       * Real width of a map (pixels).
       */
      function get realWidth() : Number;
      
      
      /**
       * Real height of a map (pixels).
       */
      function get realHeight() : Number;
      
      
      /**
       * Transforms logical coordinates to real coordinates.
       * 
       * @param logical logical coordinates of a map. <b>Not null</b>.
       * 
       * @return new instance of <code>Point</code> containing real coordinates of a map.
       */
      function logicalToReal(logical:Point) : Point;
      
      
      /**
       * Tarnsforms logical X coordinate to a real X coordinate.
       * 
       * @param logicalX logical X coordinate of a map.
       * @param logicalY logical Y coordinate of a map.
       * 
       * @return real real X coordinate of a map.
       */
      function logicalToReal_X(logicalX:int, logicalY:int) : Number;
      
      
      /**
       * Tarnsforms logical Y coordinate to a real Y coordinate.
       * 
       * @param logicalX logical X coordinate of a map.
       * @param logicalY logical Y coordinate of a map.
       * 
       * @return real real Y coordinate of a map.
       */
      function logicalToReal_Y(logicalX:int, logicalY:int) : Number;
      
      
      /**
       * Transforms real coordinates to logical coordinates.
       * 
       * @param real real coordinates of a map. <b>Not null</b>.
       * 
       * @return new instance of <code>Point</code> containing logical coordinates of a map.
       */
      function realToLogical(real:Point) : Point;
      
      
      /**
       * Tarnsforms real X coordinate to a logical X coordinate.
       * 
       * @param realX real X coordinate of a map.
       * @param realY real Y coordinate of a map.
       * 
       * @return logical X coordinate of a map.
       */
      function realToLogical_X(realX:Number, realY:Number) : int;
      
      
      /**
       * Tarnsforms real Y coordinate to a logical Y coordinate.
       * 
       * @param realX real X coordinate of a map.
       * @param realY real Y coordinate of a map.
       * 
       * @return logical Y coordinate of a map.
       */
      function realToLogical_Y(realX:Number, realY:Number) : int;
   }
}