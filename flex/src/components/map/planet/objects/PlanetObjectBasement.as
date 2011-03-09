package components.map.planet.objects
{
   import components.map.planet.PlanetMapCoordsTransform;
   
   import flash.display.Graphics;
   import flash.display.GraphicsPathCommand;
   import flash.geom.Point;
   
   import models.planet.PlanetObject;
   
   import mx.core.UIComponent;
   
   
   /**
    * Primitive that draws basement of a planet object.
    */
   public class PlanetObjectBasement extends UIComponent
   {
      private static var coordsTransform:PlanetMapCoordsTransform = new PlanetMapCoordsTransform();
      
      
      public function PlanetObjectBasement()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         focusEnabled = false;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _logicalWidth:int = 1;
      public function set logicalWidth(v:int) : void
      {
         if (_logicalWidth != v)
         {
            _logicalWidth = v;
            f_needsRedraw = true;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      public function get logicalWidth() : int
      {
         return _logicalWidth;
      }
      
      
      private var _logicalHeight:int = 1;
      public function set logicalHeight(v:int) : void
      {
         if (_logicalHeight != v)
         {
            _logicalHeight = v;
            f_needsRedraw = true;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      public function get logicalHeight() : int
      {
         return _logicalHeight;
      }
      
      
      private var _color:uint = 0;
      public function set color(value:uint) : void
      {
         if (_color != value)
         {
            _color = value;
            f_needsRedraw = true;
            invalidateDisplayList();
         }
      }
      public function get color() : uint
      {
         return _color;
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         coordsTransform.logicalWidth  = _logicalWidth;
         coordsTransform.logicalHeight = _logicalHeight;
         measuredWidth  = coordsTransform.realWidth;
         measuredHeight = coordsTransform.realHeight;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      private var f_needsRedraw:Boolean = true;
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         if (f_needsRedraw)
         {
            var g:Graphics = graphics;
            var top:Point = PlanetObject.getBasementTopCorner(logicalWidth);
            var left:Point = PlanetObject.getBasementLeftCorner(logicalWidth);
            var bottom:Point = PlanetObject.getBasementBottomCorner(logicalWidth, logicalHeight);
            var right:Point = PlanetObject.getBasementRightCorner(logicalWidth, logicalHeight);
            g.clear();
            g.beginFill(_color);
            g.drawPath(
               Vector.<int>([
                  GraphicsPathCommand.MOVE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO,
                  GraphicsPathCommand.LINE_TO
               ]),
               Vector.<Number>([
                  top.x,     top.y,
                  top.x + 1, top.y,
                  right.x, right.y,
                  right.x, right.y + 1,
                  bottom.x + 1, bottom.y,
                  bottom.x,     bottom.y,
                  left.x, left.y + 1,
                  left.x, left.y
               ])
            );
            g.endFill();
         }
         f_needsRedraw = false;
      }
   }
}