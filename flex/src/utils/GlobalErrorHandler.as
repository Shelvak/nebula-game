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
            crashed = true;
            var ML:ModelLocator = ModelLocator.getInstance();
            var message:String = 'Client error! Version ' + Version.VERSION +
               '\n\n';
            message += "Exception data:\n";
            message += 'Error id: ' + error.errorID + '\n';
            message += 'Stacktrace:\n' + error.getStackTrace() + '\n\n';
            message += ML.debugLog;
//            message += "Global unit list:\n" + ML.units + "\n\n";
//            message += "Global squads list:\n" + ML.squadrons + "\n\n";
//            message += "Global routes list:\n" + ML.routes + "\n\n";
//            message += "Global notifications list:\n" + ML.notifications;
            FlexGlobals.topLevelApplication.crash(message, !Capabilities.isDebugger);
         }
         StartupManager.resetApp();
      }
   }
}