package utils.execution
{
   import flash.utils.Dictionary;

   import utils.Objects;
   import utils.SingletonFactory;


   public class JobExecutorsManager
   {
      public static function getInstance(): JobExecutorsManager {
         return SingletonFactory.getSingletonInstance(JobExecutorsManager);
      }

      private const _activeExecutors: Dictionary = new Dictionary();

      internal function registerExecutor(executor: BaseJobExecutor): void {
         Objects.paramNotNull("executor", executor);
         _activeExecutors[executor] = executor;
      }

      internal function unregisterExecutor(executor: BaseJobExecutor): void {
         delete _activeExecutors[executor];
      }

      /**
       * Stop all active executors if any.
       */
      public function stopAll(): void {
         for each (var executor: BaseJobExecutor in _activeExecutors) {
            executor.stop();
         }
      }
   }
}
