package utils
{
   import flash.events.EventDispatcher;

   /**
    * @see utils.ApplicationLockerEvent#LOCK_CHANGE
    */
   [Event(name="lockChange", type="utils.ApplicationLockerEvent")]

   /**
    * Defines static flags that alter actions of a few controllers in a row.
    */
   public final class ApplicationLocker extends EventDispatcher
   {
      /**
       * @return allways the same instance of <code>GlobalFlags</code>
       */
      public static function getInstance(): ApplicationLocker {
         return SingletonFactory.getSingletonInstance(ApplicationLocker);
      }

      /**
      * Sets all flags to their default values.
      */
      public static function reset(): void {
         getInstance().resetLockCounter();
      }

      private var _lockCounter: int = 0;
      private function set lockCounter(value: int): void {
         if (value < 0) {
            value = 0;
         }
         if (_lockCounter != value) {
            _lockCounter = value;
            Events.dispatchSimpleEvent(
                    this,
                    ApplicationLockerEvent,
                    ApplicationLockerEvent.LOCK_CHANGE
            );
         }
      }
      private function get lockCounter(): int {
         return _lockCounter;
      }

      public function resetLockCounter(): void {
         lockCounter = 0;
      }

      public function set lockApplication(locked: Boolean): void {
         lockCounter = locked ? 1 : 0;
      }

      [Bindable(event="lockChange")]
      /**
       * If <code>true</code> user won't be able to input anything and
       * spinner will be shown.
       */
      public function get applicationLocked(): Boolean {
         return lockCounter > 0;
      }

      public function increaseLockCounter(): void {
         lockCounter++;
      }

      public function decreaseLockCounter(): void {
         lockCounter--;
      }
   }
}