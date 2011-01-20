package components.unitsscreen
{
   import components.skins.UnitsButtonSkin;
   
   import mx.events.FlexEvent;
   import mx.states.SetStyle;
   
   import spark.components.Button;
   import spark.effects.Animate;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.RepeatBehavior;
   
   public class UnitsButton extends Button
   {
      public function UnitsButton()
      {
         super();
         setStyle('skinClass', UnitsButtonSkin);
         blinkEffect.duration = BLINK_DURATION;
         blinkEffect.repeatBehavior = RepeatBehavior.REVERSE;
         blinkEffect.repeatCount = 0;
         var keys: Vector.<Keyframe> = new Vector.<Keyframe>;
         keys.push(new Keyframe(0, 0));
         keys.push(new Keyframe(BLINK_DURATION, 0.55));
         keys.push(new Keyframe(0, 0));
         var motion: MotionPath = new MotionPath('addAlpha');
         motion.keyframes = keys;
         var motions: Vector.<MotionPath> = new Vector.<MotionPath>;
         motions.push(motion);
         blinkEffect.motionPaths = motions;
      }
      
      private static const BLINK_DURATION: Number = 1000;
      [Bindable]
      private var _blink: Boolean = false;
      
      [Bindable]
      public var addAlpha: Number = 0;
      
      public function set originalColor(value: uint): void
      {
         _originalColor = value;
         actualColor = 0xffffff;
      }
      
      [Bindable]
      public var _originalColor: uint;
      [Bindable]
      public var actualColor: uint;
      
      [Bindable]
      public var ownerColorString: String = 'white';
      
      public function set blink(value: Boolean): void
      {
         _blink = value;
         refreshBlink();
      }
      
      private var blinkEffect: Animate = new Animate();
      
      private function refreshBlink(): void
      {
         if (_blink)
         {
            blinkEffect.end();
            blinkEffect.play([this]);
         }
         else
         {
            blinkEffect.end();
         }
      }
   }
}