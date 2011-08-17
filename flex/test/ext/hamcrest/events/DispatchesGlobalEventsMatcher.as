package ext.hamcrest.events
{
   import com.developmentarc.core.utils.EventBroker;
   
   import flash.events.Event;
   
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.Description;
   
   import utils.Objects;
   
   
   /**
    * Matches if a synchronous global event (through <code>EventBroker</code>) is dispatched when a function
    * item is ivoked.
    */
   public class DispatchesGlobalEventsMatcher extends BaseMatcher
   {
      /**
       * @param expectedEvents
       */
      public function DispatchesGlobalEventsMatcher(expectedEvents:Vector.<ExpectedEvent>) {
         super();
         _events = Objects.paramNotNull("expectedEvents", expectedEvents);
      }
      
      private var _events:Vector.<ExpectedEvent>;
      private var _failedEvent:ExpectedEvent;
      
      public override function matches(item:Object) : Boolean {
         var expectedEvent:ExpectedEvent;
         
         for each (expectedEvent in _events) {
            registerHandler(expectedEvent);
         }
         
         (item as Function).call();
         
         for each (expectedEvent in _events) {
            if (!expectedEvent.eventDispatched ||
                 expectedEvent.useMatcher && !expectedEvent.eventMatcher.matches(expectedEvent.event)) {
               _failedEvent = expectedEvent;
               return false;
            }
         }
         
         return true;
      }
      
      private function registerHandler(expectedEvent:ExpectedEvent) : void {
         EventBroker.subscribe(expectedEvent.eventType,
            function(event:Event) : void {
               expectedEvent.event = event;
            }
         );
      }
      
      public override function describeMismatch(item:Object, mismatchDescription:Description) : void {
         if (!_failedEvent.eventDispatched)
            mismatchDescription
               .appendText("global event ")
               .appendValue(_failedEvent.eventType)
               .appendText(" has not been dispatched");
         else
            mismatchDescription
               .appendDescriptionOf(_failedEvent.eventMatcher)
               .appendText(" ")
               .appendMismatchOf(_failedEvent.eventMatcher, _failedEvent.event);
      }
      
      public override function describeTo(description:Description) : void {
         description.appendText("global events to be dispatched:\n");
         for (var idx:int = 0; idx < _events.length; idx++) {
            var event:ExpectedEvent = _events[idx];
            description
               .appendText("\t")
               .appendValue(event.eventType);
            if (event.useMatcher) {
               description.appendText(": ");
               description.appendDescriptionOf(event.eventMatcher);
            }
            if (idx < _events.length - 1)
               description.appendText("\n");
         }
      }
   }
}