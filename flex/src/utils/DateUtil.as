package utils
{
   import com.adobe.utils.DateUtil;
   
   import models.ModelLocator;
   
   import mx.resources.ResourceManager;
   
   
   [ResourceBundle("General")]
   
   /**
    * A few static methods for working with date and time.
    */ 
   [Bindable]
   public class DateUtil
   {
      /**
       * Time difference of client and server times (serverTime - clientTime). Is updated each time
       * a message is received from server.
       * 
       * @default 0
       */
      public static var timeDiff:Number = 0;
      
      public static function updateTimeDiff(serverTimestamp:*) : void
      {
         var serverTime:Number = new Number(serverTimestamp);
         var clientTime:Number = new Date().time;
         timeDiff = serverTime - clientTime;
      }
      
      
      /**
       * Parses date and time of server format and returns that date.
       * 
       * @throws Error if the date can't be parsed.
       */ 
      public static function parseServerDTF(dateTime:String, returnLocalTime:Boolean = true) : Date
      {
         var serverTime:Date = com.adobe.utils.DateUtil.parseW3CDTF(dateTime);
         if (returnLocalTime)
         {
            return getLocalTime(serverTime);
         }
         return serverTime;
      }
      
      
      /**
       * Does the opposite to <code>getServerTime()</code>: returns time of the local machine at a
       * specified moment of server machine. This returns local time rounded to lower second.
       * 
       * @param serverTime Time of local machine.
       * 
       * @return Time of the local machine.  
       */
      public static function getLocalTime(serverTime:Date) : Date
      {
         return new Date(Math.floor((serverTime.time - timeDiff) / 1000) * 1000);
      }
      
      
      public static function secondsToHumanString(seconds: int, parts: int = 0):String
      {
         var timeString: String = "";
         
         var helper:Function = function(seconds:int, mod:int, type:String, timeString:String):Array {
            if (seconds >= mod){
               var main:int = seconds / mod;
               seconds -= main * mod;
               timeString += main.toString() + ResourceManager.getInstance().getString('General',
                  type + '.short') + " ";
            }
            
            return [seconds, timeString];
         }
            
         var ret:Array;
         ret = helper(seconds, 60 * 60 * 24, 'days', timeString);
         ret = helper(ret[0], 60 * 60, 'hours', ret[1]);
         ret = helper(ret[0], 60, 'minutes', ret[1]);
         ret = helper(ret[0], 1, 'seconds', ret[1]);
         
         timeString = (ret[1] as String);
         if (timeString == "")
         {
            timeString = '0' + ResourceManager.getInstance().getString('General','seconds.short') + ' ';
         }
         if (parts == 0)
         {
            return timeString.substring(0, timeString.length - 1);
         }
         else
         {
            var stringParts: Array = timeString.split(' ');
            timeString = stringParts[0];
            for (var i: int = 1; i<parts; i++)
            {
               timeString += ' ' + stringParts[i];
            }
            return timeString;
         }
      }
   }
}