package controllers
{
   import com.greensock.plugins.VisiblePlugin;
   
   import components.base.TopMessage;
   
   import flash.events.TimerEvent;
   import flash.utils.Timer;

   public class Messenger
   {
      private static var component: TopMessage;
      
      private static var timer: Timer = new Timer(1000, 1);
      
      public static function init(comp: TopMessage): void
      {
         component = comp;
         timer.addEventListener(TimerEvent.TIMER, hideComponent);
      }
      
      private static function hideComponent(e: TimerEvent): void
      {
         component.visible = false;
      }
      
      public static function hide(): void
      {
         component.visible = false
         timer.stop();
      }
      
      public static function show(msg: String, duration: int = 0): void
      {
         timer.stop();
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