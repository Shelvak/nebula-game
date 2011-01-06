package components.base.viewport
{
   import components.base.Scroller;
   
   import spark.components.Scroller;

   
   public class ViewportScrollable extends Viewport
   {
      private static const SCROLL_STEP_MULTIPLIER:Number = 10;
      
      
      public function ViewportScrollable()
      {
         super();
      }
      
      
      protected override function createScroller() : spark.components.Scroller
      {
         var scroller:components.base.Scroller = new components.base.Scroller();
         scroller.stepMultiplier = SCROLL_STEP_MULTIPLIER;
         scroller.preventIneffectiveEvents = true;
         return scroller;
      }
   }
}