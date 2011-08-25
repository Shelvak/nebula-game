package tests.animation
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.events.AnimatedBitmapEvent;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import org.fluint.sequence.SequenceRunner;
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   
   
   public class TC_AnimatedBitmap
   {
      // Reference declaration for class to test
      private var bmp:AnimatedBitmap;
      
      // Timer for automation of animation
      private var timer:AnimationTimer;
      
      
      public function TC_AnimatedBitmap()
      {
         timer = new AnimationTimer(10);
      };
      
      
      [Before]
      public function beforeTest() : void
      {
         runner = new SequenceRunner(this);
         bmp = new AnimatedBitmap();
         bmp.setTimer(timer);
      };
      
      
      [After]
      public function afterTest() : void
      {
         runner = null;
         timer.stop();
         bmp.cleanup();
         bmp = null;
      };
      
      
      [Test]
      public function setTimer() : void
      {
         // should not accept null value
         assertThat( function():void{ bmp.setTimer(null) }, throws (ArgumentError) );
         
         // legal [class AnimationTimer] instance should be ok
         var timer:AnimationTimer = new AnimationTimer(10);
         bmp.setTimer(timer);
         
         // timer should be set now
         assertThat( bmp.timer, equalTo (timer) );
      };
      
      
      [Test(description="checks if correctly reacts to illegal parameter values")]
      public function addAnimation_illegalParams() : void
      {
         // when [param name] is null, should throw an error 
         assertThat( function():void{ bmp.addAnimation(null, Data.seqOne) }, throws (ArgumentError) );
         
         // when [param name] is an empty string should throw an error
         assertThat( function():void{ bmp.addAnimation("", Data.seqOne) }, throws (ArgumentError) );
         
         // when [param name] contains only whitespace characters should throw an error
         assertThat( function():void{ bmp.addAnimation(" \n\t", Data.seqOne) }, throws (ArgumentError) );
         
         // when [param sequence] is null, should thrown an error
         assertThat( function():void{ bmp.addAnimation("run", null) }, throws (ArgumentError) );
         
         // when [param name] and [param sequence] are not null, should cause no errors
         bmp.addAnimation("run", Data.seqOne);
         
         // overwriting existing sequence with the same name is illegal and should cause an error
         assertThat( function():void{ bmp.addAnimation("run", Data.seqTwo) }, throws (Error) );
      };
      
      
      [Test(description="checks if addAnimation actually adds sequence objects")]
      public function addAnimation() : void
      {
         bmp.addAnimation("one", Data.seqOne);
         assertThat( bmp.getAnimation("one"), equalTo (Data.seqOne) );
         
         bmp.addAnimation("two", Data.seqTwo);
         assertThat( bmp.getAnimation("two"), equalTo (Data.seqTwo) );
      };
      
      
      [Test(description="checks if getAnimation works correctly with valid and invalid names")]
      public function getAnimation() : void
      {
         // should throw an error when [param name] is null
         assertThat( function():void{ bmp.getAnimation(null) }, throws (ArgumentError) );
         
         // should throw error when animation for a given key can't be found
         assertThat( function():void{ bmp.getAnimation("n/a") }, throws (ArgumentError) );
         
         // should not cause any errors
         bmp.addAnimation("one", Data.seqOne);
         bmp.getAnimation("one");
      };
      
      
      [Test(description="checks animationsTotal property")]
      public function animationsTotal() : void
      {
         // There should be no animations when AnimatedBitmap is initiated
         assertThat( bmp.animationsTotal, equalTo (0) );
         
         // Now there should be only one animation
         bmp.addAnimation("one", Data.seqOne);
         assertThat( bmp.animationsTotal, equalTo (1) );
         
         // And now two as we have not removed the one that we have added before
         bmp.addAnimation("two", Data.seqTwo);
         assertThat( bmp.animationsTotal, equalTo (2) );
      };
      
      
      [Test]
      public function addAnimations() : void
      {
         var anims:Object = null;
         var testForError:Function = function(errorClass:Class) : void
         {
            assertThat ( function():void{ bmp.addAnimations(anims) }, throws (errorClass) );
            bmp = new AnimatedBitmap();
            bmp.setTimer(timer);
         };
         
         // null is illegal value and should cause ArgumentError
         anims = null;
         testForError(ArgumentError);
         
         // object with illegal keys should cause an ArgumentError
         anims = {"": Data.seqOne};
         testForError(ArgumentError);
         anims = {"   ": Data.seqTwo};
         testForError(ArgumentError);
         
         // object containing instances not of Sequence class should cause an ArgumentError
         anims = {"one": null};
         testForError(ArgumentError);
         anims = {"one": "wrong type"};
         testForError(TypeError);
         
         // empty object should not cause error just no animations will be added
         bmp = new AnimatedBitmap();
         bmp.setTimer(timer);
         bmp.addAnimations({});
         assertThat( bmp.animationsTotal, equalTo (0) ),
         
         // this is ok and should not cause any errors
         bmp = new AnimatedBitmap();
         bmp.setTimer(timer);
         anims = {
            "one": Data.seqOne,
            "two": Data.seqTwo
         };
         bmp.addAnimations(anims);
         assertThat( bmp.getAnimation("one"), equalTo (Data.seqOne) );
         assertThat( bmp.getAnimation("two"), equalTo (Data.seqTwo) );
      };
      
      
      [Test(description="checks if framesData setter correctly reacts to illegal values and if properties are actually set")]
      public function setFramesData() : void
      {
         // null values are not allowed
         assertThat( function():void{ bmp.setFrames(null) }, throws (ArgumentError) );
         
         // vector containing no elements is not allowed
         assertThat( function():void{ bmp.setFrames(new Vector.<BitmapData>()) }, throws (ArgumentError) );
         
         // vector can't contain null frames
         assertThat(
            function():void{ bmp.setFrames(Vector.<BitmapData>([null])) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ bmp.setFrames(Vector.<BitmapData>([new BitmapData(1, 1), null])) },
            throws (ArgumentError)
         );
         
         // all frames must be of the same size
         assertThat(
            function():void
            {
               bmp.setFrames(Vector.<BitmapData>([new BitmapData(1, 1), new BitmapData(1, 2)]));
            },
            throws (ArgumentError)
         );
         assertThat(
            function():void
            {
               bmp.setFrames(Vector.<BitmapData>([new BitmapData(1, 1), new BitmapData(2, 1)]));
            },
            throws (ArgumentError)
         );
         
         var frameWidth:int = 5;
         var frameHeight:int = 5;
         var framesData:Vector.<BitmapData> = Vector.<BitmapData>([
            new BitmapData(frameWidth, frameHeight),
            new BitmapData(frameWidth, frameHeight)
         ]);
         framesData[0].setPixel(0, 0, 0xFF0000);
         framesData[1].setPixel(0, 0, 0x00FF00);
         
         bmp = new AnimatedBitmap();
         bmp.setTimer(timer);
         
         // this should be perfectly legal call of setFramesData()
         bmp.setFrames(framesData);
         
         // [prop framesTotal] should now be set to 2
         // [prop framesData] should return instance of BitmapData passed to setFrames() method
         // [prop frameWidth] should be set to 5
         // component should have width and height exlicitly set
         assertThat( bmp, hasProperties({
            "framesTotal": framesData.length,
            "framesData": framesData,
            "width": frameWidth,
            "height": frameHeight
         }));
         
         // [prop source] should have been instantiated, measured and should hold the first frame
         assertThat( bmp.source, notNullValue() );
         assertThat( bmp.source, hasProperties({
            "width": frameWidth,
            "height": frameHeight
         }));
         assertThat( BitmapData(bmp.source).getPixel(0, 0), equalTo (framesData[0].getPixel(0, 0)) );
         
         
         frameWidth = 7;
         frameHeight = 5;
         framesData = Vector.<BitmapData>([
            new BitmapData(frameWidth, frameHeight),
            new BitmapData(frameWidth, frameHeight),
            new BitmapData(frameWidth, frameHeight)
         ]);
         framesData[0].setPixel(0, 0, 0x00FF00);
         framesData[1].setPixel(0, 0, 0xFF0000);
         framesData[2].setPixel(0, 0, 0x0000FF);
         
         bmp = new AnimatedBitmap();
         bmp.setTimer(timer);
         
         // another legal example
         bmp.setFrames(framesData);
         
         // [prop framesTotal] should now be set to 3
         // [prop framesData] should return instance of BitmapData passed to setFrames() method
         // [prop frameWidth] should be set to 7
         // component should have width and height exlicitly set
         assertThat( bmp, hasProperties({
            "framesTotal": 3,
            "framesData": framesData,
            "width": frameWidth,
            "height": frameHeight
         }));
         
         // [prop source] should have been instantiated, measured and should hold the first frame
         assertThat( bmp.source, notNullValue() );
         assertThat( bmp.source, hasProperties({
            "width": frameWidth,
            "height": frameHeight
         }));
         assertThat( BitmapData(bmp.source).getPixel(0, 0), equalTo (framesData[0].getPixel(0, 0)) );
      };
      
      
      [Test(description="checks if frames are changed correctly")]
      public function showFrame() : void
      {
         // 3 frames of 7 px width
         bmp.setFrames(Data.framesData);
         
         // should not accept negative frame numbers
         assertThat( function():void{ bmp.showFrame(-1) }, throws (ArgumentError) );
         
         // should not accept frame numbers greater than [prop framesTotal - 1]
         assertThat( function():void{ bmp.showFrame(Data.framesTotal) }, throws (ArgumentError) );
         
         // should hold the first frame which has RED pixel in the top left corner
         bmp.showFrame(0);
         checkFrame(Data.frame0C);
         
         // should hold the second frame which has GREEN pixel in the top left corner
         bmp.showFrame(1);
         checkFrame(Data.frame1C);
         
         // should hold the second frame which has BLUE pixel in the top left corner
         bmp.showFrame(2);
         checkFrame(Data.frame2C);
      };
      
      
      [Test(description="checks if calling this method switches the 0 (default) frame")]
      public function showDefaultFrame() : void
      {
         // 3 frames of 7 px width
         bmp.setFrames(Data.framesData);
         
         // Switch to some other frame and check
         bmp.showFrame(1);
         checkFrame(Data.frame1C);
         // now switch to default frame
         bmp.showDefaultFrame();
         checkDefaultFrame();
         
         // another example
         bmp.showFrame(2);
         checkFrame(Data.frame2C);
         // now switch to default frame
         bmp.showDefaultFrame();
         checkDefaultFrame();
      };
      
      
      [Test(description="checks if playAnimation() correctly reacts to wrong parameter values")]
      public function playAnimationImmediately_badParams() : void
      {
         bmp.cleanup();
         bmp = new AnimatedBitmap();
         
         // should not allow calling playAnimation() until component has been initialized
         assertThat( function():void{ bmp.playAnimationImmediately("fly") }, throws (IllegalOperationError) );
         bmp.setFrames(Data.framesData);
         assertThat( function():void{ bmp.playAnimationImmediately("fly") }, throws (IllegalOperationError) );
         bmp.setTimer(timer);
         
         // should not accept null
         assertThat( function():void{ bmp.playAnimationImmediately(null) }, throws (ArgumentError) );
         
         // should not accept keys that don't have corresponting sequence
         assertThat( function():void{ bmp.playAnimationImmediately("none") }, throws (ArgumentError) );
      };
      
      
      [Test(async, timeout=1000)]
      public function playAnimationImmediately() : void
      {
         // "duck": new Sequence([0], null, [1, 2]);
         // "run":  new Sequence([0, 1], [0, 2], [2]);
         // "fly":  new Sequence([2, 1, 3], [0, 3], [1, 2]);
         
         
         bmp.setFrames(Data.framesData);
         bmp.addAnimations(Data.animations);
         
         addTimerStart();
         
         // start playing "duck" animation
         addCall(bmp.playAnimationImmediately, ["duck"]);
         addDefaultFrameCheck(); addAnimationCheck("duck");
         
         // check a few frames
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         
         // should still be "duck" animation
         addAnimationCheck("duck");
         
         // switch to another animation
         addCall(bmp.playAnimationImmediately, ["run"]);
         addAnimationCheck("run");
         // previously shown frame should still be visible
         addFrameCheck(1);
         
         // check a few frames
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(0);
         
         // should still be "run" animation
         addAnimationCheck("run");
         
         // switch to another animation again
         addCall(bmp.playAnimationImmediately, ["fly"]);
         addAnimationCheck("fly");
         // previously shown frame should still be visible
         addFrameCheck(0);
         
         // and check a few frames
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(3);
         addWait(); addFrameCheck(0);
         
         runner.run();
      };
      
      
      [Test(async, timeout=1000)]
      public function stopAnimationsImmediately() : void
      {
         bmp = new AnimatedBitmap();
         
         // should not let you call this method if component has not been initialized
         assertThat( function():void { bmp.stopAnimationsImmediately(); }, throws(IllegalOperationError) );
         bmp.setFrames(Data.framesData);
         assertThat( function():void { bmp.stopAnimationsImmediately(); }, throws(IllegalOperationError) );
         bmp.setTimer(timer);
         
         // "duck": new Sequence([0], null, [1, 2]);
         // "run":  new Sequence([0, 1], [0, 2], [2]);
         // "fly":  new Sequence([2, 1, 3], [0, 3], [1, 2]);
         
         bmp.addAnimations(Data.animations);
         
         addTimerStart();
         
         // start animation
         addCall(bmp.playAnimationImmediately, ["fly"]);
         addDefaultFrameCheck();
         
         // check a few frames
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(3);
         addWait(); addFrameCheck(0);
         
         // stop animation
         addCall(bmp.stopAnimationsImmediately);
         
         // previously shown frame should be visible and [prop currentAnimation] should not be set
         addFrameCheck(0); addAnimationCheck(null);
         
         addWait();
         addWait();
         
         // the same frame should be still there and [prop currentAnimation] should not be set
         addFrameCheck(0); addAnimationCheck(null);
         
         // another animation
         addCall(bmp.playAnimationImmediately, ["run"]);
         addFrameCheck(0);
         
         // check few frames and stop
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(2);
         addCall(bmp.stopAnimationsImmediately);
         
         // and check if animation has stopped (previously shown frame should be visible)
         addFrameCheck(2);
         addAnimationCheck(null);
         addWait();
         addWait();
         addFrameCheck(2);
         addAnimationCheck(null);
         
         runner.run();
      };
      
      
      [Test(async, timeout=1000)]
      public function playAnimation() : void
      {
         bmp = new AnimatedBitmap();
         
         // should not let you call this method if component has not been initialized
         assertThat( function():void { bmp.playAnimation("none"); }, throws(IllegalOperationError) );
         bmp.setFrames(Data.framesData);
         assertThat( function():void { bmp.playAnimation("none"); }, throws(IllegalOperationError) );
         bmp.setTimer(timer);
         
         // "duck": new Sequence([0], null, [1, 2]);
         // "run":  new Sequence([0, 1], [0, 2], [2]);
         // "fly":  new Sequence([2, 1, 3], [0, 3], [1, 2]);
         
         bmp.addAnimations(Data.animations);
         
         // should not accept null value
         assertThat( function():void{ bmp.playAnimation(null) }, throws (ArgumentError) );
         
         // should not accept keys that don't have corresponding sequences
         assertThat( function():void{ bmp.playAnimation("none") }, throws (ArgumentError) );
         
         addTimerStart();
         
         /**
          * lets play whole animation
          */
         addCall(bmp.playAnimation, ["duck"]);
         addWait();
         addWait();
         
         // we should have reached last animation frame
         addWait(); addAnimationCheck("duck"); addFrameCheck(2);
         // now we should still see the last frame but animation should have been reset
         addWait(); addAnimationCheck(null); addFrameCheck(2);
         
         /**
          * now check if animations are stacked and each of them is played at least once
          */
         addCall(bmp.playAnimation, ["run"]);
         
         // play until loop middle
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(0);
         
         // now tell to play another animation
         addCall(bmp.playAnimation, ["duck"]);
         
         // it should not be played at once and we should still be seeing "run"
         // however, this animation should not be looped
         addAnimationCheck("run");
         addWait(); addFrameCheck(2); addAnimationCheck("run");
         addWait(); addFrameCheck(2); addAnimationCheck("run");
         
         // now "duck" animation should be played but previously shown frame should be visible
         addWait(); addAnimationCheck("duck"); addFrameCheck(2);
         
         // check a couple of frames of that animation
         addWait(); addFrameCheck(0); addAnimationCheck("duck");
         addWait(); addFrameCheck(1); addAnimationCheck("duck");
         
         // finally two more animations to stack
         addCall(bmp.playAnimation, ["fly"]);
         addCall(bmp.playAnimation, ["run"]);
         addAnimationCheck("duck");
         
         // should have reached "duck" animation last frame
         addWait(); addFrameCheck(2); addAnimationCheck("duck");
         
         // now bitmap should have been switched to "fly" animation
         // but the last frame of "duck" should be still visible
         addWait(); addFrameCheck(2); addAnimationCheck("fly");
         
         // play "fly" animation until the end
         addWait(); addWait(); addWait(); addWait(); addWait(); addWait();
         addWait(); addAnimationCheck("fly"); addFrameCheck(2);
         
         // now it should have switched to "run" but previously shown frame should be visible
         addWait(); addAnimationCheck("run"); addFrameCheck(2);
         
         // and play a few frames with loop
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(1);
         addWait(); addFrameCheck(0); addAnimationCheck("run");
         addWait(); addFrameCheck(2);
         addWait(); addFrameCheck(0);
         addWait(); addFrameCheck(2); addAnimationCheck("run");
         
         runner.run();
      };
      
      
      [Test(async, timeout=1000)]
      public function stopAnimations() : void
      {
         bmp = new AnimatedBitmap();
         
         // should not let you call this method if component has not been initialized
         assertThat( function():void { bmp.stopAnimations(); }, throws(IllegalOperationError) );
         bmp.setFrames(Data.framesData);
         assertThat( function():void { bmp.stopAnimations(); }, throws(IllegalOperationError) );
         bmp.setTimer(timer);
         
         // "duck": new Sequence([0], null, [1, 2]);
         // "run":  new Sequence([0, 1], [0, 2], [2]);
         // "fly":  new Sequence([2, 1, 3], [0, 3], [1, 2]);
         
         bmp.addAnimations(Data.animations);
         
         addTimerStart();
         
         /**
          * Test if [method stopAnimation()] works when only one current animation is present.
          */
         
         addCall(bmp.playAnimation, ["fly"]);
         addWait(); addWait(); addAnimationCheck("fly");
         
         // now invoke [method stopAnimations()]
         addCall(bmp.stopAnimations);
         
         // we should still see "fly animation"
         addAnimationCheck("fly"); addFrameCheck(1);
         addWait(); addWait(); addWait();
         
         // should not have entered loop
         addWait(); addAnimationCheck("fly"); addFrameCheck(1);
         // last "fly" animation frame
         addWait(); addAnimationCheck("fly"); addFrameCheck(2);
         // should have stopped here but previous frame should still be visible
         addWait(); addAnimationCheck(null); addFrameCheck(2);
         
         /**
          * Now test if [method stopAnimations()] works when there are pending animations in stack.
          */
         addWait(); addCall(bmp.playAnimation, ["run"]);
         addWait(); addCall(bmp.playAnimation, ["fly"]);
         addWait(); addCall(bmp.playAnimation, ["duck"]);
         
         // ensure we are in the right frame and animation
         addWait(); addAnimationCheck("run"); addFrameCheck(0);
         
         // now stop animations
         addCall(bmp.stopAnimations);
         
         // we should see current animation playing up until the end
         addWait();
         addWait(); addAnimationCheck("run"); addFrameCheck(2);
         
         // and now complete stop but the last frame should still be visible
         addWait(); addAnimationCheck(null); addFrameCheck(2);
         
         // wait a few frames and check if other animations have not been started
         addWait(); addWait(); addAnimationCheck(null); addFrameCheck(2);
         
         runner.run();
      };
      
      
      private var allAnimationsCompleteDispatched:Boolean = false;
      private var animationCompleteDispatched:Boolean = false;
      [Ignore("This async test sometimes passes and sometimes fails")]
      [Test(async, timeout=10000, description="checks if ANIMATION_COMPLETE and ALL_ANIMATIONS_COMPLETE events are dispatched when it should be")]
      public function animationCompleteEvents() : void
      {
         bmp.setFrames(Data.framesData);
         bmp.addAnimations(Data.animations);
         bmp.addEventListener(
            AnimatedBitmapEvent.ANIMATION_COMPLETE,
            animatedBitmap_animationCompleteHandler
         );
         bmp.addEventListener(
            AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
            animatedBitmap_allAnimationsCompleteHandler
         );
         
         // "duck": new Sequence([0], null, [1, 2]);
         // "run":  new Sequence([0, 1], [0, 2], [2]);
         // "fly":  new Sequence([2, 1, 3], [0, 3], [1, 2]);
         
         addTimerStart();
         
         /**
          * ANIMATION_COMPLETE should not be dispatched when stopAnimationsImmediately() is invoked
          * ALL_ANIMATIONS_COMPLETE should also have not been dispatched
          */
         addCall(bmp.playAnimation, ["run"]);
         addDelay(20);
         addCall(bmp.stopAnimationsImmediately);
         addDelay(30);
         addNoAnimationCompleteCheck();
         addNoAllAnimationsCompleteCheck();
         
         /**
          * ANIMATION_COMPLETE sould be dispatched after stop() has been invoked on a running
          * ALL_ANIMATIONS_COMPLETE should have been dispatched
          */
         addCall(bmp.playAnimation, ["fly"]);
         addDelay(20);
         addCall(bmp.stopAnimations);
         addDelay(70);
         addAnimationCompleteCheck();
         addAllAnimationsCompleteCheck();
         
         
         /**
          * ANIMATION_COMPLETE should be dispatched for each pending animation
          * ALL_ANIMATIONS_COMPLETE should be dispached only after all animations have been played
          */
         addCall(bmp.playAnimation, ["fly"]);
         addCall(bmp.playAnimation, ["run"]);
         addCall(bmp.playAnimation, ["duck"])
         addDelay(90);
         addAnimationCompleteCheck();
         addNoAllAnimationsCompleteCheck();
         addDelay(50);
         addAnimationCompleteCheck();
         addNoAllAnimationsCompleteCheck();
         addDelay(30);
         addAnimationCompleteCheck();
         addAllAnimationsCompleteCheck();
         
         runner.run();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      include "asyncHelpers.as";
      
      
      private function addAnimationCheck(name:String) : void
      {
         addCall(checkAnimation, [name]);
      }
      
      
      private function addFrameCheck(frameNumber:int) : void
      {
         addCall(checkFrameByNumber, [frameNumber]);
      }
      
      
      private function addDefaultFrameCheck() : void
      {
         addFrameCheck(AnimatedBitmap.DEFAULT_FRAME_NUMBER);
      }
      
      
      private function checkFrame(frameColor:uint) : void
      {
         assertThat( BitmapData(bmp.source).getPixel(0, 0) , equalTo (frameColor) );
      }
      
      
      private function checkFrameByNumber(frameNumber:int) : void
      {
         assertThat( bmp.currentFrame, equalTo (frameNumber) );
         assertThat( 
            BitmapData(bmp.source).getPixel(0, 0), 
            equalTo (Data.framesData[frameNumber].getPixel(0, 0))
         );
      }
      
      
      private function checkDefaultFrame() : void
      {
         // default (0) frame should be shown
         checkFrame(Data.frame0C);
      }
      
      
      private function checkAnimation(name:String) : void
      {
         assertThat( bmp.currentAnimation, equalTo (name) );
      }
      
      
      private function animatedBitmap_animationCompleteHandler(event:AnimatedBitmapEvent) : void
      {
         animationCompleteDispatched = true;
      }
      
      
      private function animatedBitmap_allAnimationsCompleteHandler(event:AnimatedBitmapEvent) : void
      {
         allAnimationsCompleteDispatched = true;
      }
      
      
      private function checkIfAllAnimationsCompleteDispatched() : void
      {
         assertThat( allAnimationsCompleteDispatched, equalTo (true) );
         allAnimationsCompleteDispatched = false;
      }
      private function addAllAnimationsCompleteCheck() : void
      {
         addCall(checkIfAllAnimationsCompleteDispatched);
      }
      
      
      private function checkIfAllAnimationsCompleteNotDispatched() : void
      {
         assertThat( allAnimationsCompleteDispatched, equalTo (false) );
      }
      private function addNoAllAnimationsCompleteCheck() : void
      {
         addCall(checkIfAllAnimationsCompleteNotDispatched);
      }
      
      
      private function checkIfAnimationCompleteDispatched() : void
      {
         assertThat( animationCompleteDispatched, equalTo(true) );
         animationCompleteDispatched = false;
      }
      private function addAnimationCompleteCheck() : void
      {
         addCall(checkIfAnimationCompleteDispatched);
      }
      
      
      private function checkIfAnimationCompleteNotDispatched() : void
      {
         assertThat( animationCompleteDispatched, equalTo (false) );
      }
      private function addNoAnimationCompleteCheck() : void
      {
         addCall(checkIfAnimationCompleteNotDispatched);
      }
   }
}