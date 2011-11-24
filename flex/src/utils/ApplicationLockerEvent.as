package utils
{
   import flash.events.Event;

   public class ApplicationLockerEvent extends Event
   {
      /**
       * Dispatched when <code>utils.ApplicationLocker.applicationLocked</code>
       * property changes.
       */
      public static const LOCK_CHANGE:String = "lockChange";

      public function ApplicationLockerEvent(type:String) {
         super(type);
      }
   }
}
