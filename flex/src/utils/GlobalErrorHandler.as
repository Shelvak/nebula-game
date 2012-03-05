package utils
{
   import application.Version;

   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   import com.tinylabproductions.stacktracer.StacktraceError;

   import components.popups.ErrorPopup;

   import controllers.startup.StartupManager;

   import flash.external.ExternalInterface;

   import flash.system.Capabilities;

   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.logging.ILogger;
   import mx.logging.Log;

   import utils.locale.Localizer;


   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      public function handle(error: Object) : void {
         var summary: String;
         var description: String;
         var body: String;
         var slowClient: Boolean = false;

         if (error is Error) {
            var err: Error = error as Error;

            // Invalid BitmapData
            if (err.errorID == 2015) {
               showErrorPopup("invalidBitmap");
               return;
            }

            var stWoVars: String = "";
            var stWVars: String = "non-stacktracer error";

            if (error is StacktraceError) {
               var ste: StacktraceError = error as StacktraceError;
               stWoVars = ste.generateStacktrace(false);
               stWVars = ste.generateStacktrace(true);
            }
            else {
               stWoVars = err.getStackTrace();
            }

            var summaryErr: String =
                   err.name + " (error id " + error.errorID + "): " + err.message;
            summary = Version.VERSION + "|" + summaryErr;

            description = summaryErr +
                             "\n\nStacktrace (without vars):\n" +
                             stWoVars + "\n";

            body = "Stacktrace (with vars):\n" + stWVars + "\n" +
                      ModelLocator.getInstance().debugLog;

            // Error #1502: A script has executed for longer than the default
            // timeout period of 15 seconds.
            slowClient = err.errorID == 1502;
         }
         else {
            summary = "Error was " + Objects.getClassName(error) + "!";
            description = summary;
            body = "String representation:\n" + error;
         }

         crash(summary, description, body, slowClient)
      }

      private static function showErrorPopup(key: String): void {
         const popup: ErrorPopup = new ErrorPopup();
         popup.showCancelButton = false;
         popup.showRetryButton = false;
         popup.title = getString(key + ".title");
         popup.message = getString(key + ".message");
         popup.show();
      }

      private static function getString(property:String): String {
         return Localizer.string("Errors", property);
      }
         
      private static function crash(
         summary: String, description: String, body: String,
         slowClient: Boolean=false
      ): void {
         // Double escape backslashes, because strings somehow get "evaluated"
         // when they are passed to javascript.
         summary = summary.replace(/\\/g, "\\\\");
         description = description.replace(/\\/g, "\\\\");
         body = body.replace(/\\/g, "\\\\");
         ExternalInterface.call("clientError", summary, description, body);
      }
   }
}