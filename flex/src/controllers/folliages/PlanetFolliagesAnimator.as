package controllers.folliages
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.folliage.NonblockingFolliage;
   
   import mx.collections.IList;
   
   import utils.ClassUtil;
   import utils.MathUtil;
   
   
   public class PlanetFolliagesAnimator
   {
      private static const TIMER_DELAY:Number = 1000;
      private static const ANIMS_TO_TRIGGER_FROM:int = 20;
      private static const ANIMS_TO_TRIGGER_TO:int = 30;
      
      
      private var _timer:Timer = null;
      private var _folliages:IList = null;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function PlanetFolliagesAnimator()
      {
         _timer = new Timer(TIMER_DELAY);
         _timer.start();
         addTimerEventHandlers(_timer);
      }
      
      
      public function cleanup() : void
      {
         if (_folliages)
         {
            _folliages = null;
         }
         if (_timer)
         {
            removeTimerEventHandlers(_timer);
            _timer.stop();
            _timer = null;
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function setFolliages(folliages:IList) : void
      {
         ClassUtil.checkIfParamNotNull("folliages", folliages);
         _folliages = folliages;
      }
      
      
      /* ########################### */
      /* ### FOLLIAGES ANIMATION ### */
      /* ########################### */
      
      
      private function triggerAnimations() : void
      {
         if (_folliages == null || _folliages.length == 0)
         {
            return;
         }
         var animsToTrigger:int = Math.round(MathUtil.randomBetween(ANIMS_TO_TRIGGER_FROM, ANIMS_TO_TRIGGER_TO));
         for (var i:int = 0; i < animsToTrigger; i++)
         {
            var itemIndex:int = Math.round(MathUtil.randomBetween(0, _folliages.length - 1));
            NonblockingFolliage(_folliages.getItemAt(itemIndex)).swing();
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addTimerEventHandlers(timer:Timer) : void
      {
         timer.addEventListener(TimerEvent.TIMER, timer_timerEventHandler);
      }
      
      
      private function removeTimerEventHandlers(timer:Timer) : void
      {
         timer.removeEventListener(TimerEvent.TIMER, timer_timerEventHandler);
      }
      
      
      private function timer_timerEventHandler(event:TimerEvent) : void
      {
         triggerAnimations();
      }
   }
}