package ext.hamcrest.events
{
   import ext.hamcrest.object.equals;
   
   import flash.events.Event;
   
   import org.hamcrest.Matcher;
   import org.hamcrest.object.instanceOf;
   
   
   /**
    * For use in <code>DispatchesMatcher</code> and <code>DispatchesMatcherBuilder</code> classes.
    * Don't instantiate this class with <code>new</code>: better use <code>event()</code> global function.
    */
   public class ExpectedEvent
   {
      public function ExpectedEvent(eventType:String, eventMatcher:* = null)
      {
         this.eventType = eventType;
         if (eventMatcher == null ||
             eventMatcher is Matcher)
         {
            this.eventMatcher = eventMatcher;
         }
         else if (eventMatcher is Class)
         {
            this.eventMatcher = instanceOf(eventMatcher);
         }
         else if (eventMatcher is Event)
         {
            this.eventMatcher = equals(eventMatcher);
         }
         else
         {
            throw new TypeError(
               "[param eventMatcher] when provided must be of Class, Event or Matcher type but was " +
               eventMatcher
            );
         }
      }
      
      
      internal var event:Event;
      internal var eventType:String;
      internal var eventMatcher:Matcher;
      
      
      internal function get useMatcher() : Boolean
      {
         return eventMatcher != null;
      }
      
      
      internal function get eventDispatched() : Boolean
      {
         return event != null;
      }
   }
}