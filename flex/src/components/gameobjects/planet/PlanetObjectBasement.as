package components.gameobjects.planet
{
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
         _logicalWidth = v;
         f_dimensionChanged = true;
         invalidateSize();
         invalidateDisplayList();
      }
      public function get logicalWidth() : int
      {
         return _logicalWidth;
      }
      
      
      private var _logicalHeight:int = 1;
      public function set logicalHeight(v:int) : void
      {
         _logicalHeight = v;
         f_dimensionChanged = true;
         invalidateSize();
         invalidateDisplayList();
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
         
         graphics.moveTo(top.x,     top.y);
         graphics.lineTo(top.x + 1, top.y);
         graphics.lineTo(right.x, right.y);
         graphics.lineTo(right.x, right.y + 1);
         graphics.lineTo(bottom.x + 1, bottom.y);
         graphics.lineTo(bottom.x    , bottom.y);
         graphics.lineTo(left.x, left.y + 1);
         graphics.lineTo(left.x, left.y);
         graphics.lineTo(top.x, top.y);
         
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