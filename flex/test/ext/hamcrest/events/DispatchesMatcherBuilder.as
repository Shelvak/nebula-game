package ext.hamcrest.events
{
   import flash.events.IEventDispatcher;
   
   import utils.Objects;
   
   
   /**
    * Use this and <code>target(), event()</code> global functions to build a <code>DispatchesMatcher</code>
    * in a nice readable form:
    * 
    * <pre>
    * causesTarget (myTarget) .toDispatchEvent (eventType [, eventClass | eventInstance | Matcher]);
    * causesTarget (myTarget) .toDispatch (
    * &nbps;&nbps;&nbps; event (eventType [, eventClass | eventInstance | Matcher])
    * &nbps;&nbps;&nbps; event (eventType [, eventClass | eventInstance | Matcher])
    * &nbps;&nbps;&nbps; ...
    * );
    * </pre>
    */
   public class DispatchesMatcherBuilder
   {
      public function DispatchesMatcherBuilder() {
         super();
      }
      
      private var _target:IEventDispatcher;
      
      /**
       * A target to register listener on.
       * 
       * @param target instance of <code>IEventDispatcher</code> that is expected to dispatch an event.
       *               <b>Not null.</b>
       * 
       * @return this
       */
      public function causesTarget(target:IEventDispatcher) : DispatchesMatcherBuilder {
         Objects.paramNotNull("target", target);
         _target = target;
         return this;
      }
      
      /**
       * A shortcut for <code>toDispatch (event ("yourEvent"))</code>.
       * 
       * @see #toDispatch()
       */
      public function toDispatchEvent(eventType:String, eventMatcher:* = null) : DispatchesMatcher {
         return toDispatch(new ExpectedEvent(eventType, eventMatcher));
      }
      
      /**
       * Registers all given events to be dispatched by the target set using <code>causesTarget()</code>
       * method and returns <code>DispatchesMatcher</code> for further use. This method can be called after
       * <code>causesTarget()</code>.
       *  
       * @param events a list of <code>ExpectedEvent</code> instances (use <code>event()</code> function to
       *               create them)
       * 
       * @return new configured instance of <code>DispatchesMatcher</code>
       */
      public function toDispatch(... events) : DispatchesMatcher {
         var expectedEvents:Vector.<ExpectedEvent> = new Vector.<ExpectedEvent>();
         for each (var event:ExpectedEvent in events) {
            expectedEvents.push(event);
         }
         return new DispatchesMatcher(_target, expectedEvents);
      }
   }
}