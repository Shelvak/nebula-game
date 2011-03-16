package controllers.timedupdate
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;

   public class MasterUpdateTrigger
   {
      public function MasterUpdateTrigger()
      {
         // triggers must be initialized before the timer as we need to number of triggers
         // to determine delay interval of the timer
         initTriggers();
         initTimer();
         
         _timer.start();
      }
      
      
      /**
       * A list of all triggers.
       */
      private var _triggers:Vector.<IUpdateTrigger>;
      
      
      /**
       * Index of a current update trigger in action.
       */
      private var _triggerIndex:int;
      
      
      private function initTriggers() : void
      {
         _triggerIndex = -1;
         _triggers = Vector.<IUpdateTrigger>([
            new CooldownsUpdateTrigger()
         ]);
      }
      
      
      /**
       * Timer for triggering resets and updates.
       */
      private var _timer:Timer;
      
      
      private function initTimer() : void
      {
         // Simplest way to devide work: each trigger gets the same amount of time to
         // execute. Therefore all triggers should get the equal amount of workload and
         // I expect that to be difficult to atchieve.
         _timer = new Timer(1000 / _triggers.length);
         _timer.addEventListener(TimerEvent.TIMER, timer_timerHandler, false, 0, true);
      }
      
      
      private function timer_timerHandler(event:TimerEvent) : void
      {
         resetChangeFlags();
         triggerUpdate();
      }
      
      
      /**
       * Reset the flags that were (possibly) set by the previous update.
       */
      private function resetChangeFlags() : void
      {
         // after master trigger initialization _triggerIndex is -1 so just skip this step
         if (_triggerIndex > -1)
         {
            // reset the trigger that was used in previous interation
            _triggers[_triggerIndex].resetChangeFlags();
         }
      }
      
      
      /**
       * Updates the next batch of objects.
       */
      private function triggerUpdate() : void
      {
         // advance to the next trigger
         _triggerIndex++;
         if (_triggerIndex == _triggers.length)
         {
            _triggerIndex = 0;
         }
         _triggers[_triggerIndex].update();
      }
   }
}