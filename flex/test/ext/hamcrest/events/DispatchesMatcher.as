package ext.hamcrest.events
{
   import asmock.framework.Expect;
   
   import ext.hamcrest.object.equals;
   
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   import org.hamcrest.object.instanceOf;
   
   
   /**
    * Matches if a synchronous event is dispatched by the target when a function item is ivoked.
    */
   public class DispatchesMatcher extends BaseMatcher
   {
      /**
       * Consturctor.
       * 
       * @param target an object that is expected to dispatch an event.
       * @param expectedEvents list of all events expected to be dispatched by the target.
       */
      public function DispatchesMatcher(target:IEventDispatcher, expectedEvents:Vector.<ExpectedEvent>)
      {
         super();
         _target = target;
         _events = expectedEvents;
      }
      
      
      private var _target:IEventDispatcher;
      private var _events:Vector.<ExpectedEvent>;
      private var _failedEvent:ExpectedEvent;
      
      
      public override function matches(item:Object) : Boolean
      {
         var expectedEvent:ExpectedEvent;
         
         for each (expectedEvent in _events)
         {
            registerTargetHandler(expectedEvent);
         }
         
         (item as Function).call();
         
         for each (expectedEvent in _events)
         {
            if (!expectedEvent.eventDispatched ||
                 expectedEvent.useMatcher && !expectedEvent.eventMatcher.matches(expectedEvent.event))
            {
               _failedEvent = expectedEvent;
               return false;
            }
         }
         
         return true;
      }
      
      
      private function registerTargetHandler(expectedEvent:ExpectedEvent) : void
      {
         _target.addEventListener(
            expectedEvent.eventType,
            function(event:Event) : void
            {
               expectedEvent.event = event;
            }
         );
      }
      
      
      public override function describeMismatch(item:Object, mismatchDescription:Description) : void
      {
         if (!_failedEvent.eventDispatched)
         {
            mismatchDescription
               .appendValue(_target)
               .appendText(" did not dispatch ")
               .appendValue(_failedEvent.eventType)
               .appendText(" event");
         }
         else
         {
            mismatchDescription
               .appendDescriptionOf(_failedEvent.eventMatcher)
               .appendText(" ")
               .appendMismatchOf(_failedEvent.eventMatcher, _failedEvent.event);
         }
      }
      
      
      public override function describeTo(description:Description) : void
      {
         description
            .appendValue(_target)
            .appendText(" to dispatch events:\n");
         for (var idx:int = 0; idx < _events.length; idx++)
         {
            var event:ExpectedEvent = _events[idx];
            description
               .appendText("\t")
               .appendValue(event.eventType);
            if (event.useMatcher)
            {
               description.appendText(": ");
               description.appendDescriptionOf(event.eventMatcher);
            }
            if (idx < _events.length - 1)
            {
               description.appendText("\n");
            }
         }
      }
   }
}