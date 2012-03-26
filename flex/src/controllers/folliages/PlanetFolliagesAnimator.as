package controllers.folliages
{
   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;

   import flash.events.TimerEvent;
   import flash.utils.Timer;

   import models.folliage.NonblockingFolliage;
   import models.player.PlayerOptions;

   import mx.collections.IList;

   import utils.Objects;
   import utils.MathUtil;


   public class PlanetFolliagesAnimator
   {
      private static const TIMER_DELAY: Number = 1000;
      private static const ANIMS_TO_TRIGGER_FROM: int = 20;
      private static const ANIMS_TO_TRIGGER_TO: int = 30;


      private var _timer: Timer = null;
      private var _foliage: IList = null;


      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */


      public function PlanetFolliagesAnimator() {
         _timer = new Timer(TIMER_DELAY);
         _timer.start();
         addTimerEventHandlers(_timer);
      }

      public function cleanup(): void {
         if (_foliage) {
            _foliage = null;
         }
         if (_timer) {
            removeTimerEventHandlers(_timer);
            _timer.stop();
            _timer = null;
         }
      }


      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      public function setFolliages(folliages: IList): void {
         _foliage = Objects.paramNotNull("folliages", folliages);
      }


      /* ########################## */
      /* ### FOLIAGES ANIMATION ### */
      /* ########################## */


      private function triggerAnimations(): void {
         if (_foliage == null || _foliage.length == 0) {
            return;
         }
         var animsToTrigger: int = Math.round(
            MathUtil.randomBetween(ANIMS_TO_TRIGGER_FROM, ANIMS_TO_TRIGGER_TO)
         );
         for (var i: int = 0; i < animsToTrigger; i++) {
            const itemIndex: int = Math.round(
               MathUtil.randomBetween(0, _foliage.length - 1)
            );
            NonblockingFolliage(_foliage.getItemAt(itemIndex)).swing();
         }
      }


      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */

      private function addTimerEventHandlers(timer: Timer): void {
         timer.addEventListener(TimerEvent.TIMER, timer_timerEventHandler);
      }

      private function removeTimerEventHandlers(timer: Timer): void {
         timer.removeEventListener(TimerEvent.TIMER, timer_timerEventHandler);
      }

      private function timer_timerEventHandler(event: TimerEvent): void {
         if (PlayerOptions.enablePlanetAnimations &&
                MCMainArea.getInstance().currentName == MainAreaScreens.PLANET) {
            triggerAnimations();
         }
      }
   }
}