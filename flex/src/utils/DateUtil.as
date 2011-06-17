package utils
{
   import com.adobe.utils.DateUtil;
   
   import mx.formatters.DateFormatter;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   import utils.locale.Localizer;
   
   
   /**
    * A few static methods for working with date and time.
    */
   public class DateUtil
   {
      /**
       * Current time of the client machine in milliseconds.
       */
      public static var now:Number;
      
      
      /**
       * Time difference (in milliseconds) of client and server times (serverTime - clientTime). Is updated
       * each time a message is received from server.
       * 
       * @default 0
       */
      public static var timeDiff:Number = 0;
      
      
      public static function updateTimeDiff(serverTimestamp:*, clientTime:Date) : void
      {
         var serverTime:Number = new Number(serverTimestamp);
         
         var logger:ILogger = Log.getLogger("utils.DateUtil");
         logger.info("######################");
         logger.info("## TIME DIFF UPDATE ##");
         logger.info("serverTime: {0}", new Date(serverTimestamp));
         logger.info("clientTime: {0}", clientTime);
         logger.info("currentDiff: {0}", timeDiff);
         
         if (isNaN(timeDiff) || Math.abs(timeDiff) > Math.abs(serverTime - clientTime.time))
         {
            timeDiff = serverTime - clientTime.time;
            logger.info("*UPDATED* time diff. New value: {0}", timeDiff);
         }
         else
         {
            logger.info("*NOT* updated time diff. Value: {0}", serverTime - clientTime.time);
         }
         
         logger.info("## TIME DIFF UPDATE ##");
         logger.info("######################");
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
      
      
      public static function secondsToHumanString(seconds:int, parts:int = 0) : String
      {
         var timeString: String = "";
         
         var helper:Function = function(seconds:int, mod:int, type:String, timeString:String):Array {
            if (seconds >= mod){
               var main:int = seconds / mod;
               seconds -= main * mod;
               timeString += main.toString() + Localizer.string('General',
                  type + '.short') + " ";
            }
            
            return [seconds, timeString];
         }
            
         var ret:Array;
         ret = helper(seconds, 60 * 60 * 24, 'day', timeString);
         ret = helper(ret[0], 60 * 60, 'hour', ret[1]);
         ret = helper(ret[0], 60, 'minute', ret[1]);
         ret = helper(ret[0], 1, 'second', ret[1]);
         
         timeString = (ret[1] as String);
         if (timeString == "")
         {
            timeString = '0' + Localizer.string('General','second.short') + ' ';
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
      
      
      /* ############################# */
      /* ### DATE FORMAT FUNCTIONS ### */
      /* ############################# */
      
      
      /**
       * Fromats given <code>date</code> as a short date string specified by
       * <code>locale.xml/Formatters.date.shortDate</code>.
       */
      public static function formatShortDate(date:Date) : String
      {
         Objects.paramNotNull("date", date)
         return format(date, "shortDate");
      }
      
      
      /**
       * Fromats given <code>date</code> as a short date and time string specified by
       * <code>locale.xml/Formatters.date.shortDateTime</code>.
       */
      public static function formatShortDateTime(date:Date) : String
      {
         Objects.paramNotNull("date", date)
         return format(date, "shortDateTime");
      }
      
      
      private static var _formatter:DateFormatter = new DateFormatter();
      private static function format(date:Date, formatStringKey:String) : String
      {
         _formatter.formatString = Localizer.string("Formatters", "date." + formatStringKey);
         return _formatter.format(date);
      }
      
      
//      /**
//       * Adds <code>date1</code> and <code>date2</code> and returns new <code>Date</code> object.
//       * 
//       * @param date1 <b>Not null.</b>
//       * @param date2 <b>Not null.</b>
//       */
//      public static function add(date1:Date, date2:Date) : Date
//      {
//         ClassUtil.checkIfParamNotNull("date1", date1);
//         ClassUtil.checkIfParamNotNull("date2", date2);
//         return new Date(date1.time + date2.time);
//      }
//      
//      
//      /**
//       * Substracts <code>date2</code> from <code>date1</code> and returns new <code>Date</code> object.
//       * 
//       * @param date1 <b>Not null.</b>
//       * @param date2 <b>Not null.</b>
//       */
//      public static function substract(date1:Date, date2:Date) : Date
//      {
//         ClassUtil.checkIfParamNotNull("date1", date1);
//         ClassUtil.checkIfParamNotNull("date2", date2);
//         return new Date(date1.time - date2.time);
//      }
//      
//      
//      /**
//       * Converts given date to number of seconds.
//       * 
//       * @param date <b>Not null.</b>
//       */      
//      public static function toSeconds(date:Date) : Number
//      {
//         ClassUtil.checkIfParamNotNull("date", date);
//         return Math.floor(date.time / 1000);
//      }
   }
}