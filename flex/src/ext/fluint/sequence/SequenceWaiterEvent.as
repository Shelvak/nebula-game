package ext.fluint.sequence
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   import org.flexunit.async.Async;
   import org.flexunit.async.AsyncLocator;
   import org.flexunit.internals.runners.statements.IAsyncHandlingStatement;
   import org.fluint.sequence.SequenceRunner;
   import org.fluint.sequence.SequenceWaiter;
   
   
   /** 
    * This class tells the TestCase instance to pend until the eventName occurs (and call the given
    * event handler) or the timeout expires (call timeout handler).
    */	 
   public class SequenceWaiterEvent extends SequenceWaiter
   {
      /**
       * @private 
       */
      protected var _eventHandler:Function;
      
      
      /** 
       * A reference to the event handler that should be called if the event named in
       * <code>eventName</code> is dispatched before the <code>timeout</code> is reached. The
       * handler is expected to have the follow signature:
       * <code>handleEvent(event:Event) : void</code>.</br>
       * <code>event</code> parameter is an event object boradcasted by the <code>target</code>.
       */
      public function get eventHandler() : Function
      {
         return _eventHandler;
      }
      
      
      public function SequenceWaiterEvent(target:IEventDispatcher,
                                          eventName:String,
                                          eventHandler:Function,
                                          timeout:int,
                                          timeoutHandler:Function=null)
      {
         super(target, eventName, timeout, timeoutHandler);
         _eventHandler = eventHandler;
      }
      
      
      private var _asyncHandlingStatement:IAsyncHandlingStatement;
      public override function setupListeners(testCase:*, sequence:SequenceRunner) : void
      {
         _asyncHandlingStatement = AsyncLocator.getCallableForTest(testCase);
         target.addEventListener(eventName, _asyncHandlingStatement.asyncHandler(internalEventHandler, timeout, sequence, timeoutHandler), false, 0, true);
      }
      
      
      private function internalEventHandler(event:Event, sequence:SequenceRunner) : void
      {
         _eventHandler(event);
         _asyncHandlingStatement.handleNextSequence(event, sequence);
      }
   }
}