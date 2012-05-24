package controllers.timedupdate
{
   import controllers.messages.MessagesProcessor;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.units.SquadronsController;

   import flash.events.TimerEvent;
   import flash.utils.Timer;

   import interfaces.IUpdatable;

   import models.ModelLocator;

   import utils.DateUtil;
   import utils.Objects;
   import utils.TypeChecker;
   import utils.datastructures.iterators.IIteratorFactory;
   import utils.execution.GameLogicExecutionManager;


   public class MasterUpdateTrigger
   {
      /**
       * Invokes <code>update()</code> method on given <code>IUpdatable</code>
       * if it is not <code>null</code>.
       */
      public static function updateItem(updatable: IUpdatable): void {
         if (updatable != null) {
            updatable.update();
         }
      }

      /**
       * Invokes <code>update()</code> method on each <code>IUpdatable</code>
       * in the list if it is not <code>null</code>.
       */
      public static function updateList(list: *): void {
         if (list != null) {
            if (!TypeChecker.isCollection(list)) {
               throw new TypeError(
                  "[param list] must be [class Array], [class Vector] or"
                     + "[class IList] but was " + Objects.getClass(list)
               );
            }
            IIteratorFactory.getIterator(list).forEach(updateItem);
         }
      }

      /**
       * Invokes <code>resetChangeFlags()</code> method on given
       * <code>updatable</code> if it is not <code>null</code>.
       */
      public static function resetChangeFlagsOf(updatable: IUpdatable): void {
         if (updatable != null) {
            updatable.resetChangeFlags();
         }
      }

      /**
       * Invokes <code>resetChangeFlags()</code> method on each
       * <code>IUpdatable</code> in the list if it is not <code>null</code>.
       */
      public static function resetChangeFlagsOfList(list: *): void {
         if (list != null) {
            if (!TypeChecker.isCollection(list)) {
               throw new TypeError(
                  "[param list] must be [class Array], [class Vector] or "
                     + "[class IList] but was " + Objects.getClass(list)
               );
            }
            IIteratorFactory.getIterator(list).forEach(resetChangeFlagsOf);
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
      private var _triggers: Vector.<IUpdateTrigger>;

      /**
       * All triggers that were triggered after the last reset.
       */
      private var _triggersToReset: Vector.<IUpdateTrigger>;

      /**
       * Index of a current update trigger in action.
       */
      private var _triggerIndex: int;

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      private function initTriggers() : void {
         _triggerIndex = -1;
         _triggers = Vector.<IUpdateTrigger>([
            TemporaryUpdateTrigger.getInstance(),
            new SingleUpdatableUpdateTrigger(
               function (): IUpdatable { return ML.latestGalaxy }
            ),
            new SingleUpdatableUpdateTrigger(
               function (): IUpdatable { return ML.latestSSMap }
            ),
            new SingleUpdatableUpdateTrigger(
               function (): IUpdatable { return ML.latestPlanet }
            ),
            new SingleUpdatableUpdateTrigger(
               function (): IUpdatable { return ML.player }
            ),
            new SingleUpdatableUpdateTrigger(
               function (): IUpdatable { return SquadronsController.getInstance() }
            ),
            new UIUpdateTrigger()
         ]);
         _triggersToReset = new Vector.<IUpdateTrigger>();
      }

      /**
       * Timer for triggering resets and updates.
       */
      private var _timer: Timer;

      private function initTimer(): void {
         // Simplest way to divide work: each trigger gets the same amount of
         // time to execute. Therefore all triggers should get the equal amount
         // of workload and I expect that to be difficult to achieve.
         _timer = new Timer(1000 / _triggers.length);
         _timer.addEventListener(
            TimerEvent.TIMER, timer_timerHandler, false, 0, true
         );
      }

      private function timer_timerHandler(event: TimerEvent): void {
         if (GameLogicExecutionManager.getInstance().executionEnabled) {
            // For now we call this each time before triggering next batch of
            // updates. Later this will be called by the rendering mechanism
            // after all display objects are updated.
            resetChangeFlags();
            triggerUpdate();
         }
      }

      /**
       * Reset the flags that were (possibly) set by the previous updates.
       */
      private function resetChangeFlags(): void {
         if (_triggersToReset.length == 0) {
            return;
         }
         for each (var trigger: IUpdateTrigger
            in _triggersToReset.splice(0, _triggersToReset.length)) {
            trigger.resetChangeFlags();
         }
      }

      /**
       * Updates the next batch of objects.
       */
      private function triggerUpdate(): void {
         // grab current time
         DateUtil.now = new Date().time;

         // process a few messages
         MessagesProcessor.getInstance().process(5);
         ResponseMessagesTracker.getInstance().checkWaitingMessages();
         
         // advance to the next trigger
         _triggerIndex++;
         if (_triggerIndex == _triggers.length) {
            _triggerIndex = 0;
         }

         // update
         const trigger: IUpdateTrigger = _triggers[_triggerIndex];
         trigger.update();
         _triggersToReset.push(trigger);
      }
   }
}