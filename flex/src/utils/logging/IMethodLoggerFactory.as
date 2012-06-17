package utils.logging
{
   import mx.logging.ILogger;


   public interface IMethodLoggerFactory
   {
      function getLogger(method: String): ILogger;
   }
}
