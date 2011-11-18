package utils
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   
   /**
    * Contains static helper methods for working with events.
    */
   public class Events
   {
      /**
       * Use this for dispatching simple events: events with constructor that takes event type as the first
       * argument and all other arguments (if any) have default values. This method will dispatch an event if
       * <code>target.hasEventListener(type)</code> returns <code>true</code>.
       * 
       * @param target event dispatcher to dispatch event from | <b>not null</b>
       * @param CLASS event class | <b>not null</b>
       * @param type event type | <b>not null, not empty string</b>
       */
      public static function dispatchSimpleEvent(target: IEventDispatcher,
                                                 CLASS: Class,
                                                 type: String): void {
         Objects.paramNotNull("target", target);
         Objects.paramNotNull("CLASS", CLASS);
         Objects.paramNotEquals("type", type, [null, ""]);
         if (target.hasEventListener(type)) {
            target.dispatchEvent(Event(new CLASS(type)));
         }
      }
   }
}