package components.battle
{
   import animation.AnimationTimer;
   import animation.Sequence;
   import animation.events.AnimatedBitmapEvent;
   
   import config.BattleConfig;
   
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.battle.BFlank;
   import models.battle.BUnit;
   
   import utils.random.Rndm;
   
   public class BUnitComp extends BBattleParticipantComp
   {
      private static const MAX_STILL_DELAY: int = 10000;
      
      public function appear(unitId: int): void
      {
         var appearUnit: BUnit = getGroupedParticipantModel(unitId) as BUnit;
         appearGroup.removeExact(appearUnit);
         group.addItem(appearUnit);
         if (groupLength == 1)
         {
            function showGroup(e: TimerEvent): void
            {
               visible = true;
               AnimationTimer.forBattle.removeEventListener(TimerEvent.TIMER, showGroup);
            }
            playAnimation('appear');
            AnimationTimer.forBattle.addEventListener(TimerEvent.TIMER, showGroup);
         }
      }
      
      
      public function getModel() : BUnit
      {
         return model as BUnit;
      }
      
      
      public function BUnitComp(model:BUnit)
      {
         super(model);
         if (model.willAppear)
         {
            visible = false;
         }
         addEventListener(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE, playStill);
      }
      
      public function handleCreation(rand: Rndm): void
      {
         var stillInitTimer: Timer = new Timer(rand.integer(0, MAX_STILL_DELAY), 1);
         stillInitTimer.addEventListener(TimerEvent.TIMER, playStill);
         stillInitTimer.start();
         refresh();
      }
      
      private function playStill(e: Event = null): void
      {
         //TODO remove has animation, everyone has still animation
         if (getLiving() == 0 || !hasAnimation('still'))
         {
            removeEventListener(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE, playStill);
            return;
         }
         playAnimation('still');
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
      
      public function get immobile(): Boolean
      {
         return BattleConfig.getUnitImmobile(participantModel.type);
      }
      
      protected function getUnitAnimProps() : Object
      {
         return BattleConfig.getUnitAnimationProps(participantModel.type);
      }
      
      protected override function initAnimations() : void
      {
         emotionCount = 0;
         var animationProps:Object = getUnitAnimProps();
         for (var name:String in animationProps.actions)
         {
            if (name.indexOf('emotion') != -1)
               emotionCount++;
            var anim:Object = animationProps.actions[name];
            addAnimation(name, new Sequence(anim.start, anim.loop, anim.finish));
         }
      }
   }
}