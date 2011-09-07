package utils.logging.targets
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   import utils.Objects;
   import utils.SingletonFactory;

   public class MessagesLogger
   {      
      public static function getInstance() : MessagesLogger {
         return SingletonFactory.getSingletonInstance(MessagesLogger);
      }
      
      
      public function MessagesLogger() {
      }
      
      
      private var _disabledLogKeywords:Array = new Array();
      public function disableLogging(keywords:Array) : void {
         Objects.paramNotNull("keywords", keywords);
         _disabledLogKeywords = keywords;
      }
      
      /**
       * @param message message received form or beeing set to the server
       * @param logMessage log message text
       * @param params parameters to substitute in <code>logMessage</code>
       */
      public function logMessage(message:String, logMessage:String, ... params) : void {
         if (shouldBeLogged(message))
            log.info(logMessage, params);
      }
      
      private function shouldBeLogged(msg:String) : Boolean {
         Objects.paramNotNull("msg", msg);
         for each (var keyword:String in _disabledLogKeywords) {
            if (msg.indexOf(keyword) != -1)
               return false;
         }
         return true;
      }
      
      private function get log() : ILogger {
         return Log.getLogger(Objects.getClassName(this, true));
      }
   }
}