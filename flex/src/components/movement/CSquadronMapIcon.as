package components.movement
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   
   import config.Config;
   
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   import interfaces.ICleanable;
   
   import models.Owner;
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   import spark.components.Group;
   import spark.effects.Fade;
   import spark.effects.animation.RepeatBehavior;
   import spark.primitives.BitmapImage;
   
   import utils.Objects;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class CSquadronMapIcon extends Group implements ICleanable
   {
      private static const BLINK_EFFECT_DURATION:int = 500; // milliseconds
      public static const WIDTH:Number = 38;       // pixels
      public static const HEIGHT:Number = WIDTH;   // pixels
      
      
      private var _blinkEffect:Fade;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CSquadronMapIcon()
      {
         super();
         width = WIDTH;
         height = HEIGHT;
         addSelfEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         if (_levelIcon)
         {
            _levelIcon.cleanup();
            _levelIcon = null;
         }
         if (_blinkEffect)
         {
            _blinkEffect.end();
            _blinkEffect.target = null;
            _blinkEffect = null;
         }
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _squadIcon:BitmapImage;
      private var _levelIcon:AnimatedBitmap;
      
      
      protected override function createChildren():void
      {
         super.createChildren();
         
         _levelIcon = AnimatedBitmap.createInstance(
            getAnims("squad_level"),
            Config.getAssetValue("images.ui.movement.squadLevel.actions"),
            AnimationTimer.forMovement
         );
         addElement(_levelIcon);
         
         _squadIcon = new BitmapImage();
         _squadIcon.verticalCenter = _squadIcon.horizontalCenter = 0;
         _squadIcon.alpha = 1;
         addElement(_squadIcon);
         _blinkEffect = new Fade(_squadIcon);
         with (_blinkEffect)
         {
            alphaFrom = 1;
            alphaTo = 0;
            repeatCount = 0;
            repeatBehavior = RepeatBehavior.REVERSE;
            duration = BLINK_EFFECT_DURATION;
         }
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _squadron:MSquadron;
      public function set squadron(value:MSquadron) : void
      {
         if (_squadron != value)
         {
            _squadron = value;
            f_squadronChanged = true;
            invalidateProperties();
         }
      }
      public function get squadron() : MSquadron
      {
         return _squadron;
      }
      
      
      public function get squadronOwner() : int
      {
         return _squadron.owner;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _squadron.currentHop.location;
      }
      
      
      private var _selected:Boolean;
      public function set selected(value:Boolean) : void
      {
         if (_selected != value)
         {
            _selected = value;
            f_selectedChanged = true;
            invalidateProperties();
         }
      }
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      
      private var _underMouse:Boolean;
      private var _levelAnim:String;
      
      
      private var f_selectedChanged:Boolean = true,
                  f_squadronChanged:Boolean = true,
                  f_underMouseChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_squadronChanged)
         {
            if (_squadron)
            {
               _levelAnim = "set";
               var img:String = "squad_";
               switch (_squadron.owner)
               {
                  case Owner.PLAYER:
                     img += "player";
                     _levelAnim += "Green";
                     break;
                  case Owner.ALLY:
                     _levelAnim += "Blue";
                     img += "ally";
                     break;
                  case Owner.NAP:
                     _levelAnim += "White";
                     img += "nap";
                     break;
                  case Owner.NPC:   // NPC units
                     _levelAnim += "Yellow";
                     img += "npc";
                     break;
                  case Owner.ENEMY:
                     _levelAnim += "Red";
                     img += "enemy";
                     break;
               }
               _squadIcon.source = getImg(img);
            }
            else
            {
               _squadIcon.source = null;
            }
         }
         if (_blinkEffect && f_squadronChanged)
         {
            if (_squadron && _squadron.isMoving)
            {
               if (!_blinkEffect.isPlaying)
               {
                  _blinkEffect.play();
               }
            }
            else
            {
               if (_blinkEffect.isPlaying)
               {
                  _blinkEffect.end();
               }
            }
         }
         if (_levelIcon && (f_selectedChanged || f_squadronChanged || f_underMouseChanged))
         {
            if (_squadron)
            {
               if (_underMouse || _selected)
               {
                  if (_levelIcon.currentAnimation != _levelAnim)
                  {
                     _levelIcon.playAnimationImmediately(_levelAnim);
                  }
               }
               else
               {
                  _levelIcon.stopAnimationsImmediately();
                  _levelIcon.showDefaultFrame();
               }
               _levelIcon.visible = true;
               
            }
            else
            {
               _levelIcon.stopAnimationsImmediately();
               _levelIcon.visible = false;
            }
         }
         f_selectedChanged =
         f_squadronChanged =
         f_underMouseChanged = false;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public override function toString() : String
      {
         return "[class: " + Objects.getClassName(this) + ", currentLocation: " + currentLocation +
                ", squadron: " + _squadron + "]";
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.ROLL_OVER, this_rollOverHandler);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler);
      }
      
      
      private function this_rollOverHandler(event:MouseEvent) : void
      {
         _underMouse = true;
         f_underMouseChanged = true;
         invalidateProperties();
      }
      
      
      private function this_rollOutHandler(event:MouseEvent) : void
      {
         _underMouse = false;
         f_underMouseChanged = true;
         invalidateProperties();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private const IMG:ImagePreloader = ImagePreloader.getInstance();
      
      
      private function getImg(name:String) : BitmapData
      {
         return IMG.getImage(AssetNames.MOVEMENT_IMAGES_FOLDER + name);
      }
      
      
      private function getAnims(name:String) : Vector.<BitmapData>
      {
         return IMG.getFrames(AssetNames.MOVEMENT_IMAGES_FOLDER + name);
      }
      
   }
}