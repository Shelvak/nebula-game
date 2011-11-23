package utils
{
import application.Version;

import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   
   import controllers.startup.StartupManager;
   
   import flash.system.Capabilities;
   
   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   
   
   public class GlobalErrorHandler implements GlobalExceptionHandlerAction {
      private var crashed: Boolean = false;
      public function handle(error:Object) : void {
         if (error is Error && !crashed) {
            var err:Error = Error(error);
            crashed = true;
            var ML:ModelLocator = ModelLocator.getInstance();
            var message:String = 'Client error! Version ' + Version.VERSION +
               '\n\n';
            message += "Exception data:\n";
            message += 'Error id: ' + err.errorID + '\n';
            message += 'Stacktrace:\n' + err.getStackTrace() + '\n\n';
            message += ML.debugLog;
//            message += "Global unit list:\n" + ML.units + "\n\n";
//            message += "Global squads list:\n" + ML.squadrons + "\n\n";
//            message += "Global routes list:\n" + ML.routes + "\n\n";
//            message += "Global notifications list:\n" + ML.notifications;

            // Error #1502: A script has executed for longer than the default timeout period of 15 seconds.
            var slowClient: Boolean = err.errorID == 1502;
            
            FlexGlobals.topLevelApplication.crash(message, slowClient, !Capabilities.isDebugger);
         }
         StartupManager.resetApp();
      }
   }
}