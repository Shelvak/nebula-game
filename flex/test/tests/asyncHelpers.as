import flash.events.Event;
import flexunit.framework.Assert;

import org.flexunit.async.Async;

private function timeoutHandler_pass(passThroughData:Object) : void {}
private function eventHandler_fail(event:Event, passThroughData:Object) : void
{
   Assert.fail("Event '" + event.type + "' should not have been dispached");
}
private function eventHandler_empty(event:Event, passThroughData:Object) : void {}
private function asyncHandler(eventHandler:Function,
                              timeout:int,
                              passThroughData:Object = null,
                              timeoutHandler:Function = null) : Function
{
   return Async.asyncHandler(this, eventHandler, timeout, passThroughData, timeoutHandler);
}
private function asyncHandler_eventDispatchedFails(timeout:int) : Function
{
   return asyncHandler(eventHandler_fail, timeout, null, timeoutHandler_pass);
}