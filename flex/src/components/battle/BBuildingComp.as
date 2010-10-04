package components.battle
{
   import animation.Sequence;
   
   import config.BattleConfig;
   
   import models.battle.BBuilding;
   
   import utils.random.Rndm;
   
   public class BBuildingComp extends BBattleParticipantComp
   {
      public function getModel() : BBuilding
      {
         return model as BBuilding;
      }
      
      public function BBuildingComp(model:BBuilding)
      {
         super(model);
      }
      
      private var emotionCount: int = 0;
      
      public function playRandomEmotion(rand: Rndm): void
      {
         if (dead)
         {
            throw new Error(getModel().type+' is dead and cant play emotions');
         }
         if (emotionCount != 0)
            playAnimationImmediately('emotion' + rand.integer(0, emotionCount-1));
      }
      
      protected override function initAnimations() : void
      {
         emotionCount = 0;
         var animationProps:Object = getBuildingAnimProps();
         for (var name:String in animationProps.actions)
         {
            if (name.indexOf('emotion') != -1)
               emotionCount++;
            var anim:Object = animationProps.actions[name];
            addAnimation(name, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
      
      protected function getBuildingAnimProps() : Object
      {
         return BattleConfig.getBuildingAnimationProps(participantModel.type);
      }
   }
}