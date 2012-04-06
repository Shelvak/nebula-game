package utils.execution
{
   import utils.Objects;


   public class BaseJobExecutor implements IJobExecutor
   {

      private const executorsManager: JobExecutorsManager =
                       JobExecutorsManager.getInstance();

      private const logicExecutionManager: GameLogicExecutionManager =
                       GameLogicExecutionManager.getInstance();


      private var _pauseOtherProcessing: Boolean;
      private const _jobs: Array = new Array();

      public function BaseJobExecutor(pauseOtherProcessing: Boolean) {
         _pauseOtherProcessing = pauseOtherProcessing;
      }

      public function addSubJob(subJob: Function): IJobExecutor {
         _jobs.push(Objects.paramNotNull("subJob", subJob));
         return this;
      }

      /**
       * Do not override this method. Override <code>executeImpl()</code>
       * instead.
       */
      public function execute(): void {
         if (_pauseOtherProcessing) {
            logicExecutionManager.pause();
         }
         executorsManager.registerExecutor(this);
         executeImpl();
      }

      protected function executeImpl(): void {
         Objects.throwAbstractMethodError();
      }

      protected function executeNextSubJob(): void {
         if (_jobs.length > 0) {
            (_jobs.shift() as Function).call();
         }
         else {
            stop();
         }
      }

      /**
       * Do not override this method. Override <code>stopImpl()</code> instead.
       */
      internal function stop(): void {
         _jobs.splice();
         stopImpl();
         executorsManager.unregisterExecutor(this);
         if (_pauseOtherProcessing) {
            logicExecutionManager.resume();
         }
      }

      protected function stopImpl(): void {
         Objects.throwAbstractMethodError();
      }
   }
}
