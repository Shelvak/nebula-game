package utils
{
   import application.Version;

   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   import com.tinylabproductions.stacktracer.StacktraceError;

   import controllers.startup.StartupManager;

   import flash.external.ExternalInterface;

   import flash.system.Capabilities;

   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.logging.ILogger;
   import mx.logging.Log;


   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      public function handle(error: Object) : void {
         if (error is Error) {
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
            
            var head: String =
               'Client error! Version ' + Version.VERSION + '\n\n' +
               "!!! EXCEPTION !!!\n" +
               err.name + " (error id " + error.errorID + "): " +
               err.message + "\n\nStacktrace (without vars):\n" +
               stWoVars + "\n";

            var ML:ModelLocator = ModelLocator.getInstance();
            var body:String = "Stacktrace (with vars):\n" + stWVars + "\n" +
               ML.debugLog;

            // Error #1502: A script has executed for longer than the default
            // timeout period of 15 seconds.
            var slowClient: Boolean = err.errorID == 1502;
            
            crash(head, body, slowClient)
         }
         else {
            crash(
               "Error was not an Error but " + Objects.getClassName(error) +
                  "?!",
               "String representation:\n" + error
            );
         }
      }
         
      private static function crash(
         head: String, body: String, slowClient: Boolean=false
      ): void {
         // Double escape backslashes, because strings somehow get "evaluated"
         // when they are passed to javascript.
         head = head.replace(/\\/g, "\\\\");
         body = body.replace(/\\/g, "\\\\");
         ExternalInterface.call("clientError", head, body, slowClient);
      }
   }
}