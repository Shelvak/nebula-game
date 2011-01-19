package components.battle
{
   import animation.Sequence;
   
   import com.greensock.TweenLite;
   
   import config.BattleConfig;
   
   import models.battle.BProjectile;
   
   
   public class BProjectileComp extends BAnimatedBitmap
   {
      private static const FLY: String = 'fly';
      
      public function BProjectileComp(model:BProjectile)
      {
         super(model);
         if (hasAnimation(FLY))
         {
            playAnimation(FLY);
         }
      }
      
      
      public var moveTween:TweenLite = null;
      
      
      public function getModel() : BProjectile
      {
         return BProjectile(model);
      }
      
      
      public override function playAnimation(name:String) : void
      {
         try
         {
            super.playAnimation(name);
         }
         catch(err: ArgumentError)
         {
            throw new ArgumentError(getModel().gunType + ': ' + err);
         }
      }
      
      
      public override function playAnimationImmediately(name:String) : void
      {
         try
         {
            super.playAnimationImmediately(name);
         }
         catch(err: ArgumentError)
         {
            throw new ArgumentError(getModel().gunType + ': ' + err);
         }
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
   }
}