package animation
{
   import animation.events.SequencePlayerEvent;
   
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   
   import interfaces.ICleanable;
   
   import utils.Objects;
   
   
   /**
    * Dispatched when any of positioning properties - and as a result dimension (size)
    * properties - have changed.
    * 
    * @eventType animation.events.SequencePlayerEvent.SEQUENCE_COMPLETE
    */
   [Event(name="sequenceComplete", type="animation.events.SequencePlayerEvent")]
   
   
   /**
    * Used for playback of one <code>Sequence<code>. Can work in automatic mode (use <code>play()</code> and <code>strop()</code>)
    * or manual mode (use <code>nextFrame()</code>).
    * 
    * @author MikisM
    */
   public class SequencePlayer extends EventDispatcher implements ICleanable
   {
      public function SequencePlayer(animatedBitmap:AnimatedBitmap, animationTimer:AnimationTimer)
      {
         Objects.paramNotNull("animatedBitmap", animatedBitmap);
         Objects.paramNotNull("animationTimer", animationTimer);
         _animatedBitmap = animatedBitmap;
         _animationTimer = animationTimer;
      }
      
      
      public function cleanup() : void
      {
         if (_animationTimer != null)
         {
            _animationTimer.removeListener(animationTimer_timerHandler);
            _animationTimer = null;
         }
         if (_animatedBitmap != null)
         {
            _animatedBitmap = null;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _animationTimer:AnimationTimer;
      public function get animationTimer() : AnimationTimer
      {
         return _animationTimer;
      }
      
      
      private var _animatedBitmap:AnimatedBitmap;
      public function get animatedBitmap() : AnimatedBitmap
      {
         return _animatedBitmap;
      }
      
      
      private var _currentSequence:Sequence;
      public function get currentSequence() : Sequence
      {
         return _currentSequence;
      }
      
      
      private var _currentFrame:int = AnimatedBitmap.DEFAULT_FRAME_NUMBER;
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      
      private var _hasMoreFrames:Boolean = false;
      public function get hasMoreFrames() : Boolean
      {
         return _hasMoreFrames;
      }
      
      
      private var _isPlaying:Boolean = false;
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function setSequence(sequence:Sequence) : void
      {
         Objects.paramNotNull("sequence", sequence);
         stopImmediatelly();
         _currentSequence = sequence;
         _hasMoreFrames = true;
      }
      
      
      private var _currentPartType:int = SequencePartType.START;
      private var _currentPart:Array = null;
      private var _currentPartIndex:int = -1;
      public function nextFrame() : void
      {
         // We can't proceed if no more frames are left to play
         if (!hasMoreFrames)
         {
            throw new IllegalOperationError("No more frames: all frames have been shown");
         }
         
         // Animation start
         if (_currentPart == null)
         {
            if (_currentSequence.hasStartFrames)
            {
               _currentPart = _currentSequence.startFrames;
               _currentPartType = SequencePartType.START;
            }
            else if (_currentSequence.isLooped)
            {
               switchToLoopPart();
            }
            else
            {
               switchToFinishPart();
            }
            _currentPartIndex = 0;
         }
         
         // Switch to either loopFrames, finishFrames or stop animation
         else if (_currentPartIndex == _currentPart.length - 1)
         {
            switch (_currentPartType)
            {
               case SequencePartType.START:
                  if (_currentSequence.isLooped)
                  {
                     switchToLoopPart();
                  }
                  else
                  {
                     switchToFinishPart();
                  }
                  _currentPartIndex = 0;
                  break;
               
               // just get back to the first frame in the loop part
               // or if animation stop has been issued proceed to finish part
               case SequencePartType.LOOP:
                  if (_stopPending)
                  {
                     _stopPending = false;
                     switchToFinishPart();
                  }
                  _currentPartIndex = 0;
                  break;
               
               // Stop animation here
               case SequencePartType.FINISH:
                  _dispatchSequenceCompleteEvent = true;
                  stopImmediatelly();
                  return;
            }
         }
         
         // Otherwise just switch to the next frame in a current part
         else
         {
            _currentPartIndex++;
         }
         
         updateCurrentFrame();
      }
      
      
      private var _dispatchSequenceCompleteEvent:Boolean = false;
      public function stopImmediatelly() : void
      {
         _animationTimer.removeListener(animationTimer_timerHandler);
         _stopPending = false;
         _hasMoreFrames = false;
         _isPlaying = false;
         _currentSequence = null;
         _currentPart = null;
         _currentPartIndex = -1;
         _currentPartType = SequencePartType.START;
         if (_dispatchSequenceCompleteEvent)
         {
            _dispatchSequenceCompleteEvent = false;
            dispatchSequenceCompleteEvent();
         }
      }
      
      
      public function play(sequence:Sequence) : void
      {
         setSequence(sequence);
         _isPlaying = true;
         _animationTimer.addListener(animationTimer_timerHandler, 1000);
      }
      
      
      private var _stopPending:Boolean = false;
      public function stop() : void
      {
         if (_isPlaying && !_stopPending)
         {
            _stopPending = true;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Updates <code>_currentFrame</code> property and tells <code>AnimatedBitmap</code>
       * to update frame buffer.
       */
      private function updateCurrentFrame() : void
      {
         if (_currentPart)
         {
            _currentFrame = _currentPart[_currentPartIndex];
            animatedBitmap.showFrame(_currentFrame);
         }
      }
      
      
      private function animationTimer_timerHandler(event:TimerEvent) : void
      {
         nextFrame();
      }
      
      
      private function dispatchSequenceCompleteEvent() : void
      {
         if (hasEventListener(SequencePlayerEvent.SEQUENCE_COMPLETE))
         {
            dispatchEvent(new SequencePlayerEvent(SequencePlayerEvent.SEQUENCE_COMPLETE));
         }
      }
      
      
      private function switchToLoopPart(): void
      {
         _currentPart = _currentSequence.loopFrames;
         _currentPartType = SequencePartType.LOOP;
      }
      
      
      private function switchToFinishPart(): void
      {
         _currentPart = _currentSequence.finishFrames;
         _currentPartType = SequencePartType.FINISH;
         if (!_currentSequence.hasFinishFrames)
         {
            _dispatchSequenceCompleteEvent = true;
            stopImmediatelly();
         }
      }
   }
}


class SequencePartType
{
   public static const START:int = 0;
   public static const LOOP:int = 1;
   public static const FINISH:int = 2;
}