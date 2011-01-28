package utils
{
   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   
   import components.popups.ClientCrashPopup;
   
   import models.ModelLocator;
   
   import mx.utils.ObjectUtil;
   
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   
   
   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      public function handle(error:Object):void
      {
         var ML:ModelLocator = ModelLocator.getInstance();
         var PROXY:IServerProxy = ServerProxyInstance.getInstance();
         
         if (error is Error)
         {
            var popup:ClientCrashPopup = new ClientCrashPopup();
            var message:String = 'Client error!\n\n';
            message += "Exception data:\n";
            message += 'Error id: ' + error.errorID + '\n';
            message += 'Stacktrace:\n' + error.getStackTrace() + '\n\n';
            message += 'Player:\n' + objToString(ML.player) + '\n\n';
            var history:Vector.<String> = PROXY.communicationHistory;
            message += 'Message history (last ' + history.length + ' messages):\n';
            message += history.join('\n') + '\n\n';
            message += "Current galaxy:\n" + objToString(ML.latestGalaxy) + "\n\n";
            message += "Current solar system:\n" + objToString()"\n\n";
            message += "Current planet:\nTODO\n\n";
            message += "Global unit list:\nTODO";
            popup.messageText = message;
            popup.show();
         }
      }
   }
   
   
   private function objToString(object:Object) : String
   {
      return ObjectUtil.toString(object);
   }
}