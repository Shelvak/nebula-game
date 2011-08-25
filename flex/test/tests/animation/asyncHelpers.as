import flash.events.TimerEvent;

import org.fluint.sequence.SequenceCaller;
import org.fluint.sequence.SequenceDelay;
import org.fluint.sequence.SequenceWaiter;


include "../asyncSequenceHelpers.as";


private function timerWaiter() : SequenceWaiter
{
   return new SequenceWaiter(timer, TimerEvent.TIMER, 15);
}


private function addWait() : void
{
   runner.addStep(new SequenceWaiter(timer, TimerEvent.TIMER, 15));
}


private function addTimerStart() : void
{
   addCall(timer.start);
}