package components.battle
{
   import animation.Sequence;
   
   import config.BattleConfig;
   
   import flash.geom.Point;
   
   import models.battle.BProjectile;
   
   import utils.MathUtil;
   
   public class BProjectileComp extends BAnimatedBitmap
   {
      public function BProjectileComp(model:BProjectile)
      {
         super(model);
         applyFlip();
         applyRotation();
      }
      
      
      public function getModel() : BProjectile
      {
         return model as BProjectile;
      }
      
      
      protected override function initFrames() : void
      {
         setFrames(model.framesData);
      }
      
      
      protected override function initAnimations() : void
      {
         var actions:Object = BattleConfig.getGunAnimationProps(getModel().gunType).actions;
         for (var name:String in actions)
         {
            addAnimation(
               name,
               new Sequence(actions[name].start, actions[name].loop, actions[name].finish)
            );
         }
      }
      
      
      /* ############################# */
      /* ### OFFSETS AND TRANSOFRM ### */
      /* ############################# */
      
      
      private function applyFlip() : void
      {
         if (getModel().fromPosition.x > getModel().toPosition.x)
         {
            flipHorizontally();
         }
      }
      
      
      private function applyRotation() : void
      {
         rotation = MathUtil.radiansToDegrees(Math.atan(
            (getModel().toPosition.y - getModel().fromPosition.y) /
            (getModel().toPosition.x - getModel().fromPosition.x)
         ));
      }
      
      
      /**
       * Offset of projectile's head from it's original (without any transformations) destination.
       */
      public function get headOffset() : Point
      {
         var head:Point = new Point(width - 1, height / 2);
         var tHead:Point = transform.matrix.transformPoint(head);
         return tHead.subtract(head);
      }
      
      
      /**
       * Offset of projectile's tail from it's original (without any transformations) destination.
       */
      public function get tailOffset() : Point
      {
         var tail:Point = new Point(0, height / 2);
         var tTail:Point = transform.matrix.transformPoint(tail);
         return tTail.subtract(tail);
      }
   }
}