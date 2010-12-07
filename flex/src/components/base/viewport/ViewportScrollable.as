package components.base.viewport
{
   import components.base.ScrollerVariableScrollStep;
   
   import spark.components.Scroller;

   
   public class ViewportScrollable extends Viewport
   {
      private static const SCROLL_STEP_MULTIPLYER:Number = 10;
      
      
      public function ViewportScrollable()
      {
         super();
      }
      
      
      protected override function createScroller() : Scroller
      {
         var scroller:ScrollerVariableScrollStep = new ScrollerVariableScrollStep();
         scroller.stepMultiplyer = SCROLL_STEP_MULTIPLYER;
         return scroller;
      }
   }
}