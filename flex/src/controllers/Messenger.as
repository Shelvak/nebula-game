package controllers
{
   import com.greensock.plugins.VisiblePlugin;
   
   import components.base.TopMessage;
   
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import mx.events.EffectEvent;
   
   import spark.effects.Fade;
   
   public class Messenger
   {
      private static const FADE_DURATION: int = 200;
      
      public static const SHORT: int = 1000;
      public static const MEDIUM: int = 3000;
      public static const LONG: int = 8000;
      
      private static var component: TopMessage;
      
      private static var timer: Timer = new Timer(1000, 1);
      
      public static function init(comp: TopMessage): void
      {
         component = comp;
         component.alpha = 0;
         timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideMessage);
      }
      
      private static function hideMessage(e: TimerEvent): void
      {
         hide();
      }
      
      private static function resetTimer(): void
      {
         if (timer.running || timer.currentCount > 0)
         {
            timer.reset();
         }
      }
      
      private static var fade: Fade;
      
      private static function hideComponent(e: EffectEvent): void
      {
         component.visible = false;
         
      }
      
      public static function hide(): void
      {
         if (component.visible)
         {
            if (!fade || fade.alphaTo != 0)
            {
               killFade();
               fade = new Fade(component);
               fade.alphaTo = 0;
               fade.duration = FADE_DURATION;
               fade.addEventListener(EffectEvent.EFFECT_END, hideComponent);
               fade.play();
            }
         }
         
         resetTimer();
      }
      
      private static function killFade(): void
      {
         if (fade)
         {
            fade.stop();
            fade.removeEventListener(EffectEvent.EFFECT_END, hideComponent);
            fade = null;
         }
      }
      
      public static function show(msg: String, duration: int = 0): void
      {
         resetTimer();
         if (! component.visible || (fade && fade.alphaTo == 0))
         {
            killFade();
            var fade: Fade = new Fade(component);
            fade.alphaTo = 1;
            fade.duration = FADE_DURATION;
            fade.play();
         }
         
         
         component.text = msg;
         component.visible = true;
         
         if (duration != 0)
         {
            timer.delay = duration;
            timer.start();
         }
      }
   }
}