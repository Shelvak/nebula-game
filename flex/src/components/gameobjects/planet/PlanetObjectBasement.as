package components.gameobjects.planet
{
   import flash.display.GraphicsPathCommand;
   
   import models.planet.PlanetObject;
   
   import mx.core.UIComponent;
   
   
   public class PlanetObjectBasement extends UIComponent
   {
      public function PlanetObjectBasement()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      
      private var f_dimensionChanged:Boolean = true,
                  f_chromeColorChanged:Boolean = true;
      
      
      private var _logicalWidth:int = 1;
      public function set logicalWidth(v:int) : void
      {
         if (_logicalWidth != v)
         {
            _logicalWidth = v;
            f_dimensionChanged = true;
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
            f_dimensionChanged = true;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      public function get logicalHeight() : int
      {
         return _logicalHeight;
      }
      
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if (styleProp == "chromeColor")
         {
            f_chromeColorChanged = true;
            invalidateDisplayList();
         }
      }
      
      
      override protected function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (!f_dimensionChanged && !f_chromeColorChanged)
         {
            return;
         }
         
         graphics.clear();
         graphics.beginFill(getStyle("chromeColor"));
         
         var top:Object    = PlanetObject.getBasementTopCorner(logicalWidth);
         var left:Object   = PlanetObject.getBasementLeftCorner(logicalWidth);
         var bottom:Object = PlanetObject.getBasementBottomCorner(logicalWidth, logicalHeight);
         var right:Object  = PlanetObject.getBasementRightCorner(logicalWidth, logicalHeight);
         
         graphics.drawPath(
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
         
         graphics.endFill();
         
         f_dimensionChanged = f_chromeColorChanged = false;
      }
      
      
      override protected function measure() : void
      {
         measuredWidth  = PlanetObject.getRealBasementWidth(logicalWidth, logicalHeight);
         measuredHeight = PlanetObject.getRealBasementHeight(logicalWidth, logicalHeight);
      }
   }
}