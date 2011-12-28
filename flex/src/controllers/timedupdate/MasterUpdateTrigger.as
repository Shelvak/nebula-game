package controllers.timedupdate
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import interfaces.IUpdatable;
   
   import utils.DateUtil;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;

   public class MasterUpdateTrigger
   {
      /**
       * Invokes <code>update()</code> method on each <code>IUpdatable</code> in the given list.
       * 
       * @param list a list of instances of <code>IUpdatable</code>
       * <ul><b>
       * <li>Not null.</li>
       * <li>Array, Vector or IList.</li>
       * </b></ul>
       * 
       * @see controllers.timedupdate.MasterUpdateTrigger#resetChangeFlags()
       * @see interfaces.IUpdatable
       * @see interfaces.IUpdatable#update()
       */
      public static function update(list:*) : void {
         var it:IIterator = IIteratorFactory.getIterator(list);
         while (it.hasNext) {
            IUpdatable(it.next()).update();
         }
      }
      
      /**
       * Invokes <code>resetChangeFlags()</code> method on each <code>IUpdatable</code> in the given list.
       * 
       * @param list a list of instances of <code>IUpdatable</code>
       * <ul><b>
       * <li>Not null.</li>
       * <li>Array, Vector or IList.</li>
       * </b></ul>
       * 
       * @see controllers.timedupdate.MasterUpdateTrigger#update()
       * @see interfaces.IUpdatable
       * @see interfaces.IUpdatable#resetChangeFlags()
       */
      public static function resetChangeFlags(list:*) : void {
         var it:IIterator = IIteratorFactory.getIterator(list);
         while (it.hasNext) {
            IUpdatable(it.next()).resetChangeFlags();
         }
      }
      
      public function MasterUpdateTrigger() {
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
      
      
      private function initTriggers() : void {
         _triggerIndex = -1;
         _triggers = Vector.<IUpdateTrigger>([
            TemporaryUpdateTrigger.getInstance(),
            new CooldownsUpdateTrigger(),
            new PlayersUpdateTrigger(),
            new MovementUpdateTrigger()
         ]);
         _triggersToReset = new Vector.<IUpdateTrigger>();
      }
      
      
      /**
       * Timer for triggering resets and updates.
       */
      private var _timer:Timer;
      
      
      private function initTimer() : void {
         // Simplest way to divide work: each trigger gets the same amount of time to
         // execute. Therefore all triggers should get the equal amount of workload and
         // I expect that to be difficult to achieve.
         _timer = new Timer(1000 / _triggers.length);
         _timer.addEventListener(TimerEvent.TIMER, timer_timerHandler, false, 0, true);
      }
      
      
      private function timer_timerHandler(event:TimerEvent) : void {
         // For now we call this each time before triggering next batch of updates.
         // Later this will be called by the rendering mechanism after all display objects are updated.
         resetChangeFlags();
         triggerUpdate();
      }
      
      
      /**
       * Reset the flags that were (possibly) set by the previous updates.
       */
      private function resetChangeFlags() : void {
         if (_triggersToReset.length == 0)
            return;
         for each (var trigger:IUpdateTrigger in _triggersToReset.splice(0, _triggersToReset.length)) {
            trigger.resetChangeFlags();
         }
      }
      
      
      /**
       * Updates the next batch of objects.
       */
      private function triggerUpdate() : void {
         // grab current time
         DateUtil.now = new Date().time;
         
         // advance to the next trigger
         _triggerIndex++;
         if (_triggerIndex == _triggers.length)
            _triggerIndex = 0;
         
         // update
         var trigger:IUpdateTrigger = _triggers[_triggerIndex]; 
         trigger.update();
         _triggersToReset.push(trigger);
      }
   }
}