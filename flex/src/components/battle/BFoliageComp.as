package components.battle
{
   import animation.AnimatedBitmap;
   import animation.AnimationTimer;
   import animation.Sequence;
   
   import config.BattleConfig;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.random.Rndm;
   
   public class BFoliageComp extends AnimatedBitmap
   {
      public function BFoliageComp(terrainType: int, rand: Rndm)
      {
         super();
         random = rand;
         _terrainType = terrainType;
         setTimer(AnimationTimer.forBattle);
         initAnimations();
         setFrames(ImagePreloader.getInstance().getFrames(
            AssetNames.getBlockingBattlefieldFolliagesFramesFolder(_terrainType, _variation)));
      }
      
      private var random: Rndm;
      
      private var _terrainType: int;
      private var _variation: int;
      
      public var xGridPos: int;
      public var yGridPos: int;
      
      
      public function getHeightInCells(cellHeight: Number): int
      {
         return Math.ceil(height / cellHeight);
      }
      
      public function getWidthInCells(cellWidth: Number): int
      {
         return Math.ceil(width / cellWidth);
      }
      
      protected function initAnimations() : void
      {
         _variation = random.integer(0, BattleConfig.getBattlefieldFolliageVariations() - 1);
         var animationProps:Object = BattleConfig.getBattlefieldFolliageAnimations(_terrainType, _variation);
         for (var name:String in animationProps)
         {
            var anim:Object = animationProps[name];
            addAnimation(name, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
      
      public function swing() : void
      {
         if (hasAnimation("swing"))
            if (currentAnimation != "swing")
               playAnimation("swing");
      }
   }
}