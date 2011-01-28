package utils
{
   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   
   import components.popups.ClientCrashPopup;
   
   import controllers.GlobalFlags;
   import controllers.connection.ConnectionManager;
   import controllers.startup.StartupManager;
   
   import flash.system.Capabilities;
   
   import models.ModelLocator;
   
   import mx.utils.ObjectUtil;
   
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   
   
   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      public function handle(error:Object):void
      {
         if (error is Error)
         {
            var ML:ModelLocator = ModelLocator.getInstance();
            var PROXY:IServerProxy = ServerProxyInstance.getInstance();
            var message:String = 'Client error!\n\n';
            message += "Exception data:\n";
            message += 'Error id: ' + error.errorID + '\n';
            message += 'Stacktrace:\n' + error.getStackTrace() + '\n\n';
            message += 'Player:\n' + objToString(ML.player) + '\n\n';
            var history:Vector.<String> = PROXY.communicationHistory;
            message += 'Message history (last ' + history.length + ' messages):\n';
            message += history.join('\n') + '\n\n';
            message += "Active map type:\n" + objToString(ML.activeMapType) + "\n\n";
            message += "Current galaxy:\n" + objToString(ML.latestGalaxy) + "\n\n";
            message += "Current solar system:\n" + objToString(ML.latestSolarSystem) + "\n\n";
            message += "Current planet:\n" + objToString(ML.latestPlanet) + "\n\n";
            message += "Global unit list:\n" + objToString(ML.units) + "\n\n";
            message += "Global squads list:\n" + objToString(ML.squadrons) + "\n\n";
            message += "Global routes list:\n" + objToString(ML.routes) + "\n\n";
            message += "Global notifications list:\n" + objToString(ML.notifications);
            var popup:ClientCrashPopup = new ClientCrashPopup();
            popup.messageText = message;
            popup.showDebugPlayerWarning = !Capabilities.isDebugger;
            popup.show();
         }
         StartupManager.resetApp();
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      
      private function objToString(object:Object) : String
      {
         return ObjectUtil.toString(object);
      }
   }
}