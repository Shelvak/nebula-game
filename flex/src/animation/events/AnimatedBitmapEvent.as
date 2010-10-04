package animation.events
{
   import animation.AnimatedBitmap;
   
   import flash.events.Event;
   
   public class AnimatedBitmapEvent extends Event
   {
      /**
       * Dispatched for each completed animation in <code>AnimatedBitmap</code> instance.
       * 
       * @eventType animationComplete
       */
      public static const ANIMATION_COMPLETE:String = "animationComplete";
      
      /**
       * Dispatched when all animations pending have been played by <code>AnimatedBitmap</code>
       * instance.
       * 
       * @eventType allAnimationsComplete
       */
      public static const ALL_ANIMATIONS_COMPLETE:String = "allAnimationsComplete";
      
      
      /**
       * Type alias of <code>target</code> property.
       */
      public function getTarget() : AnimatedBitmap
      {
         return target as AnimatedBitmap;
      }
      
      
      /**
       * Constructor.
       */
      public function AnimatedBitmapEvent(type:String)
      {
         super(type, false, false);
      }
   }
}