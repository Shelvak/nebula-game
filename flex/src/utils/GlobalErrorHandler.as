package utils
{
   import com.adobe.ac.logging.GlobalExceptionHandlerAction;
   
   import models.ModelLocator;
   
   import mx.core.FlexGlobals;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   import spark.components.TextArea;
   
   import utils.remote.ServerConnector;
   
   public class GlobalErrorHandler implements GlobalExceptionHandlerAction
   {
      private static const LOG:ILogger = Log.getLogger("UncaughtException");
      
      public function handle(error:Object):void
      {
         if (error is Error)
         {
            var message:String = 'Client error occured! Go play other games!\n\n';
            message += "Exception data:\n";
            message += 'Error id: ' + error.errorID + '\n';
            message += 'Stacktrace:\n' + error.getStackTrace() + '\n\n';
            message += 'Player: ' + ModelLocator.getInstance().player.toString() + '\n\n';
            var history:Vector.<String> = ServerConnector.getInstance().communicationHistory;
            message += 'Message history (last ' + history.length + ' messages):\n';
            message += history.join('\n') + '\n\n';
            message += "Current galaxy:\nTODO\n\n";
            message += "Current solar system:\nTODO\n\n";
            message += "Current planet:\nTODO\n\n";
            message += "Global unit list:\nTODO\n\n";
            message += "And other things not mentioned here. Have a happy debug!";
            
            var tb: TextArea = new TextArea();
            tb.text = message;
            tb.left = 10;
            tb.top = 10;
            tb.right = 10;
            tb.bottom = 10;
            tb.setStyle('contentBackgroundColor', 0x000000);
            FlexGlobals.topLevelApplication.addElement(tb);
         }
      }
   }
}