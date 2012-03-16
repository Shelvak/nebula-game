package utils.execution
{
   import flash.errors.IllegalOperationError;

   import utils.SingletonFactory;


   public class GameLogicExecutionManager
   {
      public static function getInstance(): GameLogicExecutionManager {
         return SingletonFactory.getSingletonInstance(GameLogicExecutionManager);
      }

      private var _pauseRequestsCounter: uint = 0;

      /**
       * Pauses execution of game logic which includes:
       * <ul>
       *    <li>Processing of incoming messages</li>
       *    <li>Periodically updating models with <code>MasterUpdateTrigger</code></li>
       *    <li>Periodically dispatching <code>TIMED_UPDATE</code> global event</li>
       * </ul>
       *
       * Note that you must call <code>resume()</code> method to restore normal
       * execution. Moreover each call to <code>pause()</code> must have a
       * corresponding call to <code>resume()</code>.
       */
      public function pause(): void {
         _pauseRequestsCounter++;
      }

      /**
       * Resumes normal execution of a game logic. If you invoke this method
       * without calling <code>pause()</code> first, error will be thrown.
       */
      public function resume(): void {
         if (executionEnabled) {
            throw new IllegalOperationError(
               "A call resume() must be matched with a previous call to " +
                  "pause() but pause() has not been called"
            );
         }
         _pauseRequestsCounter--;
      }

      public function get executionEnabled(): Boolean {
         return _pauseRequestsCounter == 0;
      }
   }
}
