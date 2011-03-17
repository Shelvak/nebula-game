package controllers.timedupdate
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import utils.DateUtil;

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
       * All triggers that were triggered after the last reset.
       */
      private var _triggersToReset:Vector.<IUpdateTrigger>;
      
      
      /**
       * Index of a current update trigger in action.
       */
      private var _triggerIndex:int;
      
      
      private function initTriggers() : void
      {
         _triggerIndex = -1;
         _triggers = Vector.<IUpdateTrigger>([
            new CooldownsUpdateTrigger(),
            new SSUpdateTrigger()
         ]);
         _triggersToReset = new Vector.<IUpdateTrigger>();
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
         // For now we call this each time before triggering next batch of updates.
         // Later this will be called by the rendering engine after all display objects are updated.
         resetChangeFlags();
         triggerUpdate();
      }
      
      
      /**
       * Reset the flags that were (possibly) set by the previous updates.
       */
      private function resetChangeFlags() : void
      {
         if (_triggersToReset.length == 0)
         {
            return;
         }
         for each (var trigger:IUpdateTrigger in _triggersToReset.splice(0, _triggersToReset.length))
         {
            trigger.resetChangeFlags();
         }
      }
      
      
      /**
       * Updates the next batch of objects.
       */
      private function triggerUpdate() : void
      {
         // grab current time
         DateUtil.currentTime = new Date().time;
         
         // advance to the next trigger
         _triggerIndex++;
         if (_triggerIndex == _triggers.length)
         {
            _triggerIndex = 0;
         }
         _triggers[_triggerIndex].update();
         
         _triggersToReset.push(_triggers[_triggerIndex]);
      }
   }
}