/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/16/12
 * Time: 11:13 AM
 * To change this template use File | Settings | File Templates.
 */
package controllers.players {
   import controllers.connection.ConnectionManager;

   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;

   public class MultiAccountController {
      private var generatedNumber: int;

      private var name: String;

      private var _timer: Timer;

      private static const CHECK_GENERATED_NUMBER_EVERY: int = 5000;

      public function MultiAccountController(_name: String) {
         var so: SharedObject;
         so = SharedObject.getLocal('nebula44Accounts', '/');
         generatedNumber = Math.round(Math.random() * 9999999);
         name = _name;
         so.data[name] = generatedNumber;
         so.flush();
         startTimer();
      }

      private function startTimer(): void
      {
         _timer = new Timer(CHECK_GENERATED_NUMBER_EVERY);
         _timer.addEventListener(TimerEvent.TIMER, checkGeneratedNumber);
         _timer.start();
      }

      private function checkGeneratedNumber(event: TimerEvent): void
      {
         var so: SharedObject = SharedObject.getLocal('nebula44Accounts', '/');
         if (generatedNumber != so.data[name])
         {
            ConnectionManager.getInstance().serverWillDisconnect('multiAccount', false);
            stop();
         }
      }

      public function stop(): void
      {
         if (_timer != null)
         {
            _timer.removeEventListener(TimerEvent.TIMER, checkGeneratedNumber);
            _timer.stop();
            _timer = null;
         }
      }
   }
}
