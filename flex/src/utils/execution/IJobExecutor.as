package utils.execution
{
   public interface IJobExecutor
   {
      /**
       * A sub job function that must be executed. Does not take any parameters.
       *
       * @param job | <b>not null</b>
       */
      function addSubJob(job: Function): IJobExecutor;

      /**
       * Call this to start processing after you have added all sub jobs.
       */
      function execute(): void;
   }
}
