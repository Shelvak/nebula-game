package components.chat
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.Sequence;
   
   import flash.display.BitmapData;
   
   import mx.states.State;
   
   import spark.components.supportClasses.Skin;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CChatOpenChanButtonSkin extends Skin
   {
      private static const STATE_UP:String = "up",
                           STATE_OVER:String = "over",
                           STATE_DOWN:String = "down",
                           STATE_DISABLED:String = "disabled",
                           STATE_NEW_MESSAGE:String = "newMessage";
      
      
      private static var _animTimer:AnimationTimer;
      private static function get animTimer() : AnimationTimer
      {
         if (_animTimer == null)
         {
            // blinking does not happen that often but I need this to be not a very long delay
            // so that buttons do not appear to be laggy when user interacts
            _animTimer = new AnimationTimer(100);
            _animTimer.start();
         }
         return _animTimer;
      }
      
      
      
      public function CChatOpenChanButtonSkin()
      {
         super();
         addState(STATE_UP);
         addState(STATE_OVER);
         addState(STATE_DOWN);
         addState(STATE_DISABLED);
         addState(STATE_NEW_MESSAGE);
      }
      
      
      /**
       * Typed reference to host component.
       */
      public var hostComponent:CChatOpenChanButton;
      
      
      /**
       * Its easy to make the button blink with <code>AnimatedBitmap</code>.
       */
      private var _image:AnimatedBitmap;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _image = new AnimatedBitmap();
         with (_image)
         {
            setFrames(Vector.<BitmapData>([
               getImage(STATE_UP),
               getImage(STATE_OVER),
               getImage(STATE_DOWN),
               getImage(STATE_DISABLED)
            ]));
            addAnimation(STATE_UP, new Sequence(null, null, [0]));
            addAnimation(STATE_OVER, new Sequence(null, null, [1]));
            addAnimation(STATE_DOWN, new Sequence(null, null, [2]));
            addAnimation(STATE_DISABLED, new Sequence(null, null, [3]));
            addAnimation(STATE_NEW_MESSAGE, new Sequence(null, [0, 0, 0, 0, 0, 1, 1, 1, 1, 1], null));
            setTimer(animTimer);
         }
         addElement(_image);
      }
      
      
      protected override function stateChanged(oldState:String, newState:String, recursive:Boolean) : void
      {
         super.stateChanged(oldState, newState, recursive);
         _image.playAnimationImmediately(newState);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function addState(name:String) : void
      {
         var state:State = new State();
         state.name = name;
         states.push(state);
      }
      
      
      private function getImage(key:String) : BitmapData
      {
         return ImagePreloader.getInstance().getImage(
            AssetNames.CHAT_IMAGES_FOLDER + "btn_chan_" + hostComponent.imageKeySpecificPart + "_" + key
         );
      }
   }
}