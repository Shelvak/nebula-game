import animation.Sequence;

import ext.fluint.sequence.SequenceWaiterEvent;

import flash.events.IEventDispatcher;

import org.fluint.sequence.SequenceCaller;
import org.fluint.sequence.SequenceDelay;
import org.fluint.sequence.SequenceRunner;
import org.fluint.sequence.SequenceWaiter;


private var runner:SequenceRunner = null;


private function caller(method:Function, args:Array = null) : SequenceCaller
{
   return new SequenceCaller(null, method, args);
}


private function waiter(target:IEventDispatcher, eventName:String, timeout:int = 50, timeoutHandler:Function = null) : SequenceWaiter
{
   return new SequenceWaiter(target, eventName, timeout, timeoutHandler);
}


private function waiterEvent(target:IEventDispatcher, eventName:String, eventHandler:Function, timeout:int = 50, timeoutHandler:Function = null) : SequenceWaiterEvent
{
   return new SequenceWaiterEvent(target, eventName, eventHandler, timeout, timeoutHandler);
}


private function addWaitFor(target:IEventDispatcher, eventName:String, timeout:int = 50, timeoutHandler:Function = null) : void
{
   runner.addStep(waiter(target, eventName, timeout, timeoutHandler))
}


private function addWaitForEvent(target:IEventDispatcher, eventName:String, eventHandler:Function, timeout:int = 50, timeoutHandler:Function = null) : void
{
   runner.addStep(waiterEvent(target, eventName, eventHandler, timeout, timeoutHandler));
}


private function addCall(method:Function, args:Array = null) : void
{
   runner.addStep(caller(method, args));
}


private function addDelay(delay:int) : void
{
   runner.addStep(new SequenceDelay(delay));
}