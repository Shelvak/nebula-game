package tests.animation
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.SequencePlayer;
   import animation.events.SequencePlayerEvent;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import flexunit.framework.Assert;
   
   import org.fluint.sequence.SequenceDelay;
   import org.fluint.sequence.SequenceRunner;
   import org.fluint.sequence.SequenceWaiter;
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;

   public class TC_SequencePlayer
   {
      // reference to an instance of a class to test
      private var player:SequencePlayer;
      
      // reference to instance of AnimatedBitmap
      private var bmp:AnimatedBitmap;
      
      // Animation timer for automatic playback testing
      private var timer:AnimationTimer;
      
      // Used by tests that check if SEQUENCE_COMPLETE event has not been dispatched from the player
      private var sequenceCompleteDispatched:Boolean = false;
      
      
      public function TC_SequencePlayer() : void
      {
         timer = new AnimationTimer(10);
         bmp = new AnimatedBitmap();
         bmp.setFrames(Data.framesData);
      };
      
      
      [Before]
      public function setUp() : void
      {
         sequenceCompleteDispatched = false;
         runner = new SequenceRunner(this);
         player = new SequencePlayer(bmp, timer);
      };
      
      
      [After]
      public function tearDown() : void
      {
         runner = null;
         player.cleanup();
         timer.stop();
      }
      
      
      [Test(description="checks if constructor of a sequnce reacts correctly to invalid parameters and if appropriate properties are set")]
      public function initPlayer() : void
      {
         // should not accept null values for [param animatedBitmap]
         assertThat( function():void{ new SequencePlayer(null, timer) }, throws (ArgumentError) );
         
         // should not accept null values for [param animationTimer]
         assertThat( function():void{ new SequencePlayer(bmp, null) }, throws (ArgumentError) );
         
         // providing valid instance of [class AnimatedBitmap] should not cause any errors
         player = new SequencePlayer(bmp, timer);
         
         assertThat( player, hasProperties({
            "animatedBitmap": bmp,
            "animationTimer": timer
         }));
      };
      
      
      [Test]
      public function setSequence() : void
      {
         // should not accept null values
         assertThat ( function():void{ player.setSequence(null) }, throws (ArgumentError) );
         
         // valid instance of [class Sequence] should be ok
         player.setSequence(Data.seqOne);
         
         // [prop currentSequence] should be set
         // [prop isPlaying ] should be false
         // [prop hasMoreFrames] should be true
         // [prop currentFrame] should be AnimatedBitmap.DEFAULT_FRAME_NUMBER
         assertThat( player, hasProperties({
            "currentSequence": Data.seqOne,
            "isPlaying": false,
            "hasMoreFrames": true
         }));
         checkFrame(AnimatedBitmap.DEFAULT_FRAME_NUMBER);
         
         
         // when new sequence is set palyer should reset itself
         // however it should have more frames
         player.nextFrame();
         player.nextFrame();
         player.setSequence(Data.seqTwo); 
         assertThat( player, hasProperties({
            "currentSequence": Data.seqTwo,
            "isPlaying": false,
            "hasMoreFrames": true
         }));
         checkFrame(1);
      };
      
      
      [Test(description="test when only start and finish parts are present in a sequence")]
      public function nextFrame_startAndFinish() : void
      {
         // seqOne = new Sequence([0], null, [1, 2]);
         player.setSequence(Data.seqOne);
         
         // Now frame 0 should be displayed
         player.nextFrame(); checkFrame(0);
         
         // Now frame 1 should be displayed
         player.nextFrame(); checkFrame(1);
         
         // Finally the last frame
         player.nextFrame(); checkFrame(2);
         // The last frame must be shown until the next call to nextFrame() and only then
         // player should have no more frames
         player.nextFrame(); checkFrame(2);
         assertThat( player.hasMoreFrames, equalTo (false) );
         
         
         // Now if we call nextFrame() error should be thrown
         assertThat( function():void{ player.nextFrame() }, throws (IllegalOperationError) );
      };
      
      
      [Test(description="test when all three parts in a sequence exist")]
      public function nextFrame_allParts() : void
      {
         // seqTwo = new Sequence([0, 1], [0, 2], [2]);
         player.setSequence(Data.seqTwo);
         
         // frame 0 should be shown
         player.nextFrame(); checkFrame(0);
         
         // frame 1 should be shown
         player.nextFrame(); checkFrame(1);
         
         // frame 0 should be shown
         player.nextFrame(); checkFrame(0);
         
         // frame 2 should be shown
         player.nextFrame(); checkFrame(2);
         
         // frame 0 should be shown again
         player.nextFrame(); checkFrame(0);
         
         // frame 2 should be shown again
         player.nextFrame(); checkFrame(2);
         
         // now stop the player immediately
         player.stopImmediatelly();
         // same frame should be shown
         checkFrame(2);
         
         // Now if we call nextFrame() error should be thrown
         assertThat( function():void{ player.nextFrame() }, throws (IllegalOperationError) );
      };
      
      
      [Test(description="test when only finish part in sequence is present")]
      public function nextFrame_onlyFinish() : void
      {
         // seqThree = new Sequence(null, null, [2, 1]);
         player.setSequence(Data.seqThree);
         
         // frame 2 should be shown
         player.nextFrame(); checkFrame(2);
         
         // frame 1 should be shown
         player.nextFrame(); checkFrame(1);
         // The last frame must be shown until the next call to nextFrame() and only then
         // player should have no more frames
         player.nextFrame(); checkFrame(1);
         
         // Now if we call nextFrame() error should be thrown
         assertThat( function():void{ player.nextFrame() }, throws (IllegalOperationError) );
      };
      
      
      /* ######################################## */
      /* ### AUTOMATIC SEQUENCE PLAYBACK TEST ### */
      /* ######################################## */
      
      
      [Test(async, timeout=1000, description="test automatic playback of sequence without repeat part")]
      public function play_withoutRepeat() : void
      {
         // seqOne = new Sequence([0], null, [1, 2]);
         player.play(Data.seqOne);
         
         // play() should set sequence to value of [param sequence] and all relevant properties
         // should be set
         assertThat( player, hasProperties({
            "currentSequence": Data.seqOne,
            "isPlaying": true,
            "hasMoreFrames": true,
            "currentFrame": AnimatedBitmap.DEFAULT_FRAME_NUMBER
         }));
         
         addTimerStart();
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(2);
         addPlayerStopCheck(2);
         
         runner.run();
      };
      
      
      [Test(async, timeout=500, description="tests automatic playback of sequence with repeat part")]
      public function play_withRepeat() : void
      {
         // seqTwo = new Sequence([0, 1], [0, 2], [2]);
         player.play(Data.seqTwo);
         assertThat( player, hasProperties({
            "currentSequence": Data.seqTwo,
            "isPlaying": true,
            "hasMoreFrames": true,
            "currentFrame": AnimatedBitmap.DEFAULT_FRAME_NUMBER
         }));
         
         addTimerStart();
         
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         
         // entering loop part
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(2);
         
         // to the beginning of the loop
         addWait(); addFrameCheck(0);
         
         // tell player to stop, but not immediately: rest of the sequence must be played
         addCall(player.stop);
         
         // we should have 2 frames left
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(2);
         addPlayerStopCheck(2);
         
         runner.run();
      };
      
      
      [Test(async, timeout=100, description="checks if stop() works when player is currently playing start part")]
      public function stop_fromStart() : void
      {
         // seqLong = new Sequence([2, 1, 3], [0, 3], [1, 2]);
         player.play(Data.seqAllParts);
         
         addWait(); addFrameCheck(2);
         addWait();
         
         // Tell player to stop (frame 1 is shown and player is currently working with start frames)
         addCall(player.stop);
         addWait();
         
         // frame 0 is shown and player is currently working with loop part
         addWait(); addFrameCheck(0);
         
         // should have reached the end of loop frames
         addWait(); addFrameCheck(3);
         
         // new loop should have not been started and player should now show frame 1 and should
         // be working with finish frames
         addWait(); addFrameCheck(1);
         
         // in at most 20 milliseconds SEQUENCE_COMPLETE should be dispatched and player should be reset
         addPlayerStopCheck(2);
      };
      
      
      [Test(async, timeout=100, description="checks if stop() works when player is currently playing loop part")]
      public function stop_fromLoop() : void
      {
         // seqLoopFinish = new Sequence(null, [1, 2], [3, 1]);
         player.play(Data.seqLoopFinish);
         
         // we start from loop part at once
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(2)
         
         // back to loop start again
         addWait(); addFrameCheck(1);
         
         // adding stop call
         addCall(player.stop);
         
         // we should still see all three frames playing before complete stop
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(3);
         addWait(); addFrameCheck(1);
         addPlayerStopCheck(1);
      };
      
      
      [Test(async, timeout=50, description="checks if stop() works wen player is currently wokring on finish part")]
      public function stop_fromFinish() : void
      {
         // seqThree = new Sequence(null, null, [2, 1]);
         player.play(Data.seqThree);
         
         // we start form frame 2 in finish part
         addWait(); addFrameCheck(2);
         
         // add stop call
         addCall(player.stop);
         
         // we should see the last frame when player stops
         addWait(); addFrameCheck(1);
         addPlayerStopCheck(1);
      };
      
      
      [Test(async, timeout=500, description="when player is not playing invoking stop() should not dispatch SEQUENCE_COMPLETE event")]
      public function stop_notPlaying() : void
      {
         player.addEventListener(
            SequencePlayerEvent.SEQUENCE_COMPLETE,
            asyncHandler(sequenceCompleteHandler_fail, 200, null, timeoutHandler_pass)
         );
         player.stop();
      };
      
      
      
      [Test(async, timeout=500, description="when stopImmediatelly() is called manually should not dispatch SEQUENCE_COMPLETE event")]
      public function stopImmediately_manualCall() : void
      {
         // seqTwo = new Sequence([0, 1], [0, 2], [2]);
         player.play(Data.seqTwo);
         player.addEventListener(
            SequencePlayerEvent.SEQUENCE_COMPLETE,
            function(event:SequencePlayerEvent) : void { sequenceCompleteDispatched = true; }
         );
         
         addTimerStart();
         addWait();
         addWait();
         
         // now player should be reset
         addCall(player.stopImmediatelly);
         addCall(checkPlayerStop);
         
         // wait for SEQUENCE_COMPLETE event just in case
         runner.addStep(new SequenceDelay(20));
         addCall(function() : void {
            // SEQUENCE_COMPLETE event should not have been dispatched
            assertThat ( sequenceCompleteDispatched, equalTo (false) );
         });
         
         runner.run();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      include "../asyncHelpers.as";
      include "asyncHelpers.as";
      
      
      private function sequenceCompleteHandler_fail(event:SequencePlayerEvent, passThroughData:Object = null) : void
      {
         Assert.fail("SEQUENCE_COMPLETE event should not have been dispatched");
      }
      
      
      private function checkPlayerStop() : void
      {
         assertThat( player, hasProperties({
            "currentSequence": null,
            "isPlaying": false,
            "hasMoreFrames": false
         }));
      }
      
      
      private function playerStopTimeoutHandler(passThroughData:Object) : void
      {
         Assert.fail("player has not dispatched SequencePlayer.SEQUENCE_COMPLETE event");
      }
      
      
      private function checkFrame(frameNumber:int) : void
      {
         assertThat( player.currentFrame, equalTo (frameNumber) ); 
         assertThat( 
            BitmapData(bmp.source).getPixel(0, 0), 
            equalTo (Data.framesData[frameNumber].getPixel(0, 0))
         );
      }
      
      
      private function addPlayerStopCheck(stopFrameNumber:int) : void
      {
         // SEQUENCE_COMPLETE event should be dispatched and player should be reset
         runner.addStep(
            new SequenceWaiter(
               player,
               SequencePlayerEvent.SEQUENCE_COMPLETE,
               50,
               playerStopTimeoutHandler
            )
         );
         addCall(checkPlayerStop);
         addFrameCheck(stopFrameNumber);
      }
      
      
      private function addFrameCheck(frameNumber:int) : void
      {
         addCall(checkFrame, [frameNumber]);
      }
   }
}