package utils
{
   import application.Version;

   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   import com.tinylabproductions.stacktracer.StacktraceError;

   import controllers.startup.StartupManager;
   
   import flash.system.Capabilities;

   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.logging.ILogger;
   import mx.logging.Log;


   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      private var firstTime:Boolean = true;

      private function get logger(): ILogger {
         return Log.getLogger("utils.GlobalErrorHandler");
      }

      public function handle(error: Object) : void {
         var logger: ILogger = this.logger;

         if (error is Error) {
            if (firstTime) {
               var err: Error = error as Error;

               var stWoVars: String = "";
               var stWVars : String = "non-stacktracer error";

               if (error is StacktraceError) {
                  var ste: StacktraceError = error as StacktraceError;
                  stWoVars = ste.generateStacktrace(false);
                  stWVars  = ste.generateStacktrace(true);
               }
               else {
                  stWoVars = err.getStackTrace();
               }
               
               var head: String = "!!! EXCEPTION !!!\n" +
                  err.name + " (error id " + error.errorID + "): " +
                  err.message + "\n\nStacktrace (without vars):\n" +
                  stWoVars + "\n";

               var ML:ModelLocator = ModelLocator.getInstance();
               var message:String = 'Client error! Version ' + Version.VERSION +
                  '\n\n';
               message += head
               message += "Stacktrace (with vars):\n" + stWVars + "\n";
               message += ML.debugLog;

               // Error #1502: A script has executed for longer than the default
               // timeout period of 15 seconds.
               var slowClient: Boolean = err.errorID == 1502;

               var game: SpaceGame = SpaceGame(FlexGlobals.topLevelApplication);
               game.crash(message, slowClient, false);
               firstTime = false;
            }
            logger.info("Resetting due to crash.");
            StartupManager.resetApp();
         }
         else {
            logger.info(
               "Error was not an Error but {0}?! String representation: {1}",
               Objects.getClassName(error), error
            );
         }
      }
   }
}