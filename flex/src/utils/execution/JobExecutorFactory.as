package utils.execution
{
   public class JobExecutorFactory
   {
      public static function frameBasedExecutor(pauseOtherProcessing: Boolean): IJobExecutor {
         return new FrameBasedJobExecutor(pauseOtherProcessing);
      }
   }
}
