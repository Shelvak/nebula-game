package animation
{
   import animation.events.AnimatedBitmapEvent;
   import animation.events.SequencePlayerEvent;
   
   import com.adobe.utils.StringUtil;
   import com.developmentarc.core.datastructures.utils.Queue;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import interfaces.ICleanable;
   
   import spark.primitives.BitmapImage;
   
   import utils.ClassUtil;
   
   
   /**
    * Dispatched when each distinct animation has been played back form start to finish.
    * Mehtod is not dispatched if you call <code>stopAnimationsImmediately()</code> or
    * <code>playAnimationsImmediately()</code>.
    * 
    * @eventType animation.events.AnimatedBitmapEvent
    */
   [Event(name="animationComplete", type="animation.events.AnimatedBitmapEvent")]
   
   /**
    * Dispatched when all animations (current and all pending) have been played. Event is not
    * dispatched if you call <code>stopAnimationsImmediately()</code> or
    * <code>playAnimationsImmediately()</code>.
    */
   [Event(name="allAnimationsComplete", type="animation.events.AnimatedBitmapEvent")]
   
   
   /**
    * Use this for animation of images. This class accepts only <code>BitmapData</code>
    * objects as source for frames. Moreover you must not set <code>source</code> property
    * directly. You must use <code>setFrames()</code> for that.
    * 
    * <p>Component should be created and initialized in the following way:
    * <ol>
    *    <li>Create instance by using <code>new</code> keyword;</li>
    *    <li>
    *       Call <code>setFrames()</code>, <code>setTimer()</code> and <code>addAnimations()</code>
    *       (these methods can be called in any order). Instead of calling <code>addAnimations()</code>
    *       you can add animations you need using sequence of calls to <code>addAnimation()</code>;
    *    </li>
    * </ol>
    * Another way is to call static method <code>createInstance()</code> providing all necessary
    * parameters and this method will return newly created and ready-to-use instance of
    * <code>AnimatedBitmap</code>.</p>
    * <p>You do not have (nor should you) explicitly set size of the component: it will determine
    * its size at once when <code>setFrames()</code> is called.</p>
    * 
    * <p><b>Important!</b> When you no longer need the instance you must call
    * <code>cleanup()</code> in order it may be garbage collected. Not doing so will
    * <strong>definitely</strong> cause memory leaks and significat performace loss during
    * time. And when you call <code>cleanup()</code> method you will no longer be able to call
    * any animation related mothods and read or set properties. You should check if property
    * <code>isReady</code> is <code>true</code> before calling any of the methods (and properties)
    * mentioned if you are unsure if the component can safely be used.</p>
    * 
    * <p>For information about using this component see documentation of public methods.</p>
    */
   public class AnimatedBitmap extends BitmapImage implements ICleanable
   {
      public static const DEFAULT_FRAME_NUMBER:int = 0;
      
      
      private var _animations:Object = null;
      private var _sequencePlayer:SequencePlayer = null;
      
      
      /**
       * Creates and returns ready-to-use istance of <code>AnimatedBitmap</code>.
       * 
       * <p>All parameters are required. Passing <code>null</code> for at least one of them
       * will cause runtime error.</p>
       * 
       * @param framesData <code>Vector</code> containing all frames
       * @param animations object containing all animations that can be played by this component
       * @param timer instance of <code>AnimationTimer</code> wich will determine FPS rate
       * 
       * @return new and ready-to-use instance of <code>AnimatedBitmap</code>
       * 
       * @see #setFrames()
       * @see #setTimer()
       * @see #setAnimations()
       */
      public static function createInstance(framesData:Vector.<BitmapData>,
                                            animations:Object,
                                            timer:AnimationTimer) : AnimatedBitmap
      {
         var instance:AnimatedBitmap = new AnimatedBitmap();
         instance.setFrames(framesData);
         instance.setTimer(timer);
         var sequences:Object = new Object();
         for (var name:String in animations)
         {
            var anim:Object = animations[name];
            if (anim is Sequence)
            {
               sequences[name] = anim;
            }
            else
            {
               sequences[name] = new Sequence(anim.start, anim.loop, anim.finish);
            }
         }
         instance.addAnimations(sequences);
         return instance;
      }
      
      
      /**
       * Constructor.
       */
      public function AnimatedBitmap()
      {
         super();
         _animations = new Object();
      }
      
      
      private function initializeSequencePlayer() : void
      {
         _sequencePlayer = new SequencePlayer(this, _timer);
         _sequencePlayer.addEventListener(
            SequencePlayerEvent.SEQUENCE_COMPLETE,
            sequencePlayer_sequenceCompleteHandler
         );
      }
      
      
      private var _cleanupCalled:Boolean = false;
      /**
       * Unregisters any listeners previously registered on other objects and destroys
       * any internal objects that need to be destroyed. You <b>must</b> call this method
       * when you not longer need this instance at once because of the reasons defined
       * in the documentation of the class.
       * 
       * @see AnimatedBitmap
       */
      public function cleanup() : void
      {
         if (!_cleanupCalled)
         {
            _sequencePlayer.cleanup();
            _sequencePlayer.removeEventListener(
               SequencePlayerEvent.SEQUENCE_COMPLETE,
               sequencePlayer_sequenceCompleteHandler
            );
            _sequencePlayer = null;
            _timer = null;
            getSource().dispose();
            source = null;
            _cleanupCalled = true;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * Indicates if the component can be used that is:
       * <ul>
       *    <li>if it has been initialized and</li>
       *    <li>if <code>cleanup()</code> has not been called</li>
       * </ul>
       *  
       * @return <code>true</code> if the component can be used or <code>false</code> otherwise
       * 
       * @see #cleanup()  
       */
      public function get isReady() : Boolean
      {
         return !_cleanupCalled && _timer != null && framesData != null;
      }
      
      
      
      private var _framesData:Vector.<BitmapData> = null;
      /**
       * <code>BitmapData</code> containing all frames.
       */
      public function get framesData() : Vector.<BitmapData>
      {
         return _framesData;
      }
      
      
      private var _animationsTotal:int = 0;
      /**
       * Number of distinct animations available.
       */
      public function get animationsTotal() : int
      {
         return _animationsTotal;
      }
      
      
      /**
       * Total number of frames contained in <code>framesData</code>.
       */
      public function get framesTotal() : int
      {
         return framesData.length;
      }
      
      
      private var _currentAnimation:String = null;
      /**
       * Name of animation that is currently beeing played. If no animation is played -
       * <code>null</code>.
       * 
       * @see #isPlaying
       */
      public function get currentAnimation() : String
      {
         return _currentAnimation;
      }
      
      
      /**
       * Indicates if an animation is currently beeing played.
       * 
       * @see #currentAnimation
       */
      public function get isPlaying() : Boolean
      {
         return _currentAnimation != null;
      }
      
      
      private var _timer:AnimationTimer = null;
      /**
       * <code>AnimationTimer</code> that drives speed of animations.
       * 
       * @see #setTimer()
       */
      public function get timer() : AnimationTimer
      {
         return _timer;
      }
      
      
      private var _currentFrame:int = -1;
      /**
       * Number of a frame that is beeing displayed currently.
       */
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      
      /**
       * This is <code>true</code> if at leats one animation has been added. 
       */
      public function get hasAnimations() : Boolean
      {
         return _animationsTotal > 0;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * (Initialization method) Sets timer for this <code>AnimatedBitmap</code>.
       * <code>AnimatedBitamp</code> does not control the time and only listens for
       * <code>TimerEvent.TIMER</code> event. Therefore the timer must be controlled elsewhere
       * manually.
       * 
       * @param timer instance of <code>AnimationTimer</code>. Can't be <code>null</code>
       */
      public function setTimer(timer:AnimationTimer) : void
      {
         ClassUtil.checkIfParamNotNull("timer", timer);
         _timer = timer;
         initializeSequencePlayer();
      }
      
      
      /**
       * Returns <code>Sequence</code> object that corresponds to a given name (key).
       * 
       * @param name name of an animation. Can't be <code>null</code>
       * 
       * @return instance of <code>Sequence</code> corresponding to a given <code>name</code>
       * 
       * @throws ArgumentError if <code>name</code> does not have corresponding <code>Sequence</code> object
       */
      public function getAnimation(name:String) : Sequence
      {
         ClassUtil.checkIfParamNotNull("name", name);
         checkIfAnimationExists(name);
         return _animations[name];
      }
      
      
      /**
       * Lets you find out if this component has given animation defined.
       * 
       * @param name name of an animation
       * 
       * @return <code>true</code> if this <code>AnimatedBitmap</code> has the given animation or
       * <code>false</code> otherwise
       */
      public function hasAnimation(name:String) : Boolean
      {
         return _animations[name] != undefined && _animations[name] != null;
      }
      
      
      /**
       * Adds all animations in the given object to this <code>AnimatedBitmap</code> so that
       * they could be played later.
       * 
       * @param animations a generic object containing all animations to add. Can't be
       * <code>null</code>. The format of the object must be as follows:
       * <pre>
       * {
       * &nbsp;&nbsp;&nbsp;"[name]": [class animation.Sequence],
       * &nbsp;&nbsp;&nbsp;"[name]": [class animation.Sequence],
       * &nbsp;&nbsp;&nbsp;...
       * }
       * </pre>
       * For example:
       * <pre>
       * {
       * &nbsp;&nbsp;&nbsp;"fly": new Sequence(...),
       * &nbsp;&nbsp;&nbsp;"run": new Sequence(...)
       * }
       * </pre>
       * Note that name of animation can be nor <code>null</code> neither empty string.
       * 
       * @see #addAnimation()
       */
      public function addAnimations(animations:Object) : void
      {
         ClassUtil.checkIfParamNotNull("animations", animations);
         for (var name:String in animations)
         {
            addAnimation(name, Sequence(animations[name]));
         }
      }
      
      
      /**
       * Adds animation with a given name for later use.
       * 
       * @param name name of the animation. Can be nor <code>null</code> neither empty string
       * @param sequence instance od <code>animations.Sequence</code> containing
       * information about this animation. Can't be <code>null</code>
       * 
       * @see Sequence
       */
      public function addAnimation(name:String, sequence:Sequence) : void
      {
         ClassUtil.checkIfParamNotNull("name", name);
         ClassUtil.checkIfParamNotNull("sequence", sequence);
         name = StringUtil.trim(name);
         if (name.length == 0)
         {
            throw new ArgumentError("[param name] can't be empty or only contain whitespace characters");
         }
         if (_animations[name] != undefined && _animations[name] != null)
         {
            throw new Error("Sequence [" + name + "] already exists.");
         }
         _animations[name] = sequence;
         _animationsTotal++;
      }
      
      
      /**
       * (Initialization method) Sets frames.
       * 
       * @param framesData <code>Vector</code> containing all frames for animation. Can't be
       * <code>null</code>, can't contain <code>null</code> values, each isntance of
       * <code>BitmapData</code> must be of the same size as all others.
       */
      public function setFrames(framesData:Vector.<BitmapData>) : void
      {
         ClassUtil.checkIfParamNotNull("framesData", framesData);
         
         // Check if vector is not empty
         if (framesData.length == 0)
         {
            throw new ArgumentError("[param framesData] must contain at least one frame");
         }
         
         // Check if we got null values
         var nullIndices:Array = []; 
         for (var i:int = 0; i < framesData.length; i++)
         {
            if (framesData[i] == null)
            {
               nullIndices.push(i);
            }
         }
         if (nullIndices.length > 0)
         {
            throw new ArgumentError(
               "[param framesData] can't contain null items. \n" +
               "Nulls were instead of these frames: " + nullIndices.join(", ")
            );
         }
         
         // Check if all frames are of the same size (first frame is the reference)
         var badFrames:Array = [];
         var refWidth:int = framesData[0].width;
         var refHeight:int = framesData[0].height;
         for (i = 1; i < framesData.length; i++)
         {
            var width:int = framesData[i].width;
            var height:int = framesData[i].height;
            if (refWidth != width || refHeight != height)
            {
               badFrames.push({"index": i, "width": width, "height": height});
            }
         }
         if (badFrames.length > 0)
         {
            var message:String =
               "All frames must be of the same size.\n" +
               "Reference frame (0) is of size [w = " + refWidth + ", h = " + refHeight + "], " +
               "but other frames had different size:\n";
            for each (var badFrameData:Object in badFrames)
            {
               message += "[" + badFrameData.index +
                  ": w = " + badFrameData.width +
                  ", h = " + badFrameData.height + "]\n";
            }
            throw new ArgumentError()
         }
         
         
         _framesData = framesData;
         
         // Instantiate source property that will hold current frame
         source = new BitmapData(refWidth, refHeight);
         
         // Set component's dimensions
         this.width = refWidth;
         this.height = refHeight;
         
         showDefaultFrame();
      }
      
      
      /**
       * Immediately shows frame with a given number. Numbering of frames starts from 0.
       * 
       * @param frameNumber number of a frame to show. Must fall into the range
       * <code>[0; totalFrames - 1]</code> (inclusive)
       */
      public function showFrame(frameNumber:int) : void
      {
         if (frameNumber < 0 || frameNumber >= framesTotal)
         {
            throw new ArgumentError("[param frameNumber] must not be negative (was: " + frameNumber + 
				") and must be less than [prop framesTotal] (was: " + framesTotal + ")");
         }
         // avoid copying same frame pixels or when component is not visible
         if (visible && _currentFrame != frameNumber)
         {
            _currentFrame = frameNumber;
            getSource().copyPixels(
               framesData[frameNumber],
               new Rectangle(0, 0, frameWidth, frameHeight),
               new Point(0, 0)
            );
         }
      }
      
      
      /**
       * Immediately shows default frame.
       */
      public function showDefaultFrame() : void
      {
         showFrame(DEFAULT_FRAME_NUMBER);
      }
      
      
      private var _animationsPending:Queue = new Queue(Queue.FIFO);
      /**
       * Schedules playback of animation. That means if no animation is currently beeing played
       * given animation is started immediately. Otherwise adds this animation to list of pending
       * animations. Once current animation and all animations scheduled prior are played back,
       * the given animation will kick off.
       * 
       * @param name name of animation to play. Can be nor <code>null</code> neither empty string.
       * Must be the name of existing animation.
       */
      public function playAnimation(name:String) : void
      {
         checkIfInitialized();
         ClassUtil.checkIfParamNotNull("name", name);
         checkIfAnimationExists(name);
         _animationsPending.add(name);
         stopCurrentAnimation();
         playAnotherAnimation();
      }
      
      
      /**
       * Stops current animation: it will be played back without loop until it has finished.
       * All other scheduled animations aren't played and are removed from pending animations
       * list.
       */
      public function stopAnimations() : void
      {
         checkIfInitialized();
         stopCurrentAnimation();
         _animationsPending.removeAll();
      }
      
      
      /**
       * Sops current animation (if there is one playing) and plays given animation immediatelly.
       * All animations scheduled before are removed from list of pending animations.
       * 
       * @param name name of animation to play. Can be nor <code>null</code> neither empty string.
       * Must be the name of existing animation.
       */
      public function playAnimationImmediately(name:String) : void
      {
         checkIfInitialized();
         ClassUtil.checkIfParamNotNull("name", name);
         checkIfAnimationExists(name);
         
         _animationsPending.removeAll();
         _currentAnimation = name;
         _sequencePlayer.play(getAnimation(name));
      }
      
      
      /**
       * Stops current animation immediately and removes all scheduled animations.
       */
      public function stopAnimationsImmediately() : void
      {
         checkIfInitialized();
         _sequencePlayer.stopImmediatelly();
         _currentAnimation = null;
         _animationsPending.removeAll();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * If <code>currentAnimation</code> is <code>null</code>, will try to play another
       * animation in <code>pendingAnimations</code> stack. If there are none, nothing will
       * happen and <strong>error won't be thrown</strong>.
       */
      private function playAnotherAnimation() : void
      {
         if (!_currentAnimation && _animationsPending.hasItems)
         {
            _currentAnimation = _animationsPending.next();
            _sequencePlayer.play(getAnimation(_currentAnimation));
            // if there are still animations in stack, we need to schedule
            // a stop for current animation
            if (_animationsPending.hasItems)
            {
               stopCurrentAnimation();
            }
         }
      }
      
      
      /**
       * This only calls _sequencePlayer.stop() which does not have immediate effect.
       * Current animation will be played back to the end and only then it will be
       * actually stopped.
       */
      private function stopCurrentAnimation() : void
      {
         if (_currentAnimation)
         {
            _sequencePlayer.stop();
         }
      }
      
      
      /**
       * Typed alias for <code>source</code>.
       */
      public function getSource() : BitmapData
      {
         return BitmapData(source);
      }
      
      
      private function get frameWidth() : int
      {
         return framesData[0].width;
      }
      
      
      private function get frameHeight() : int
      {
         return framesData[0].height;
      }
      
      
      private function checkIfInitialized() : void
      {
         if (framesData == null)
         {
            throw new IllegalOperationError("[class AnimatedBitmap] has not been initialized yet: " +
                                            "have you forgotten to call [method setFrames()]?");
         }
         else if (_timer == null)
         {
            throw new IllegalOperationError("[prop timer] has not been set: have you forgotten" +
                                            "to call [method setTimer()]?");
         }
      }
      
      
      private function checkIfAnimationExists(name:String) : void
      {
         if (_animations[name] == undefined || _animations[name] == null)
         {
            throw new ArgumentError("Animation with name '" + name + "' could not be found: have " +
               "you forgotten to add animations?");
         }
      }
      
      
      public function dispatchAnimationCompleteEvent() : void
      {
         dispatchEvent(new AnimatedBitmapEvent(AnimatedBitmapEvent.ANIMATION_COMPLETE));
      }
      
      
      public function dispatchAllAnimationsCompleteEvent() : void
      {
         dispatchEvent(new AnimatedBitmapEvent(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE));
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function sequencePlayer_sequenceCompleteHandler(event:SequencePlayerEvent) : void
      {
         _currentAnimation = null;
         dispatchAnimationCompleteEvent();
         if (!_animationsPending.hasItems)
         {
            dispatchAllAnimationsCompleteEvent();
         }
         else
         {
            playAnotherAnimation();
         }
      }
   }
}