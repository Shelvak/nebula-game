package components.base.viewport
{
   import components.base.Scroller;
   
   import spark.components.Scroller;

   
   public class ViewportScrollable extends Viewport
   {
      private static const SCROLL_STEP_MULTIPLYER:Number = 10;
      
      
      public function ViewportScrollable()
      {
         super();
      }
      
      
      protected override function createScroller() : spark.components.Scroller
      {
         var scroller:components.base.Scroller = new components.base.Scroller();
         scroller.stepMultiplyer = SCROLL_STEP_MULTIPLYER;
         scroller.preventIneffectiveEvents = true;
         return scroller;
      }
   }
}