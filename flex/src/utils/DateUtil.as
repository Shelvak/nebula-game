package utils
{
   import com.adobe.utils.DateUtil;
   
   import mx.formatters.DateFormatter;
   
   import utils.locale.Localizer;
   
   
   /**
    * A few static methods for working with date and time.
    */
   public class DateUtil
   {
      /**
       * Type processor function for <code>Objects</code>.
       */
      public static function autoCreate(currValue:Date, value:String) : Date {
         var valueDate:Date = parseServerDTF(value);
         if (currValue != null) {
            currValue.time = valueDate.time;
            return currValue;
         }
         return valueDate;
      }
      
      /**
       * January 1, 1970
       */
      public static const BEGINNING:Date = new Date(0);
      
      /**
       * Current time of the client machine in milliseconds.
       */
      public static var now:Number;
      
      /**
       * Time difference (in milliseconds) of client and server times (serverTime - clientTime). Is updated
       * each time a message is received from server.
       * 
       * @default NaN
       * 
       * @internal
       * This *MUST* be a NaN (NOT 0) for updateTimeDiff() to work. See the code of that method
       * and you will see why!
       */
      public static var timeDiff:Number = NaN;

      public static function updateTimeDiff(serverTimestamp: *,
                                            clientTime: Date): void {
         var serverTime: Number = new Number(serverTimestamp);
         var newDiff: Number = serverTime - clientTime.time;
         if (isNaN(timeDiff) || Math.abs(timeDiff) > Math.abs(newDiff)) {
            timeDiff = newDiff;
         }
      }
      
      /**
       * Parses date and time of server format and returns that date.
       * 
       * @throws Error if the date can't be parsed.
       */
      public static function parseServerDTF(dateTime: String,
                                            returnLocalTime: Boolean = true): Date {
         var serverTime: Date = com.adobe.utils.DateUtil.parseW3CDTF(dateTime);
         if (returnLocalTime) {
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
      public static function getLocalTime(serverTime: Date): Date {
         return new Date(
            Math.floor((serverTime.time - timeDiff) / 1000) * 1000
         );
      }

      public static function secondsToHumanString(seconds: int,
                                                  parts: int = 0): String {
         var timeString: String = "";

         function helper(seconds: int,
                         mod: int,
                         type: String,
                         timeString: String): Array {
            if (seconds >= mod) {
               var main: int = seconds / mod;
               seconds -= main * mod;
               timeString += main.toString()
                                + Localizer.string('General', type + '.short')
                                + " ";
            }

            return [seconds, timeString];
         }

         var ret: Array;
         ret = helper(seconds, 60 * 60 * 24, 'day', timeString);
         ret = helper(ret[0], 60 * 60, 'hour', ret[1]);
         ret = helper(ret[0], 60, 'minute', ret[1]);
         ret = helper(ret[0], 1, 'second', ret[1]);

         timeString = (ret[1] as String);
         if (timeString == "") {
            timeString = '0' + Localizer.string('General', 'second.short') + ' ';
         }
         if (parts == 0) {
            return timeString.substring(0, timeString.length - 1);
         }
         else {
            var stringParts: Array = timeString.split(' ');
            timeString = stringParts[0];
            var actualParts: int = Math.min(stringParts.length, parts);
            for (var i: int = 1; i < actualParts; i++) {
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
      public static function formatShortDate(date: Date): String {
         Objects.paramNotNull("date", date);
         return format(date, "shortDate");
      }

      /**
       * Fromats given <code>date</code> as a short date and time string specified by
       * <code>locale.xml/Formatters.date.shortDateTime</code>.
       */
      public static function formatShortDateTime(date: Date): String {
         Objects.paramNotNull("date", date);
         return format(date, "shortDateTime");
      }

      private static var _formatter: DateFormatter = new DateFormatter();
      private static function format(date: Date,
                                     formatStringKey: String): String {
         _formatter.formatString = Localizer.string(
            "Formatters", "date." + formatStringKey
         );
         return _formatter.format(date);
      }

      private static const SECONDS_IN_DAY: int = 24 * 60 * 60;

      /* returns Rounded + 1 */
      public static function secondsToDays(elapsedTime: Number): int {
         return Math.round(elapsedTime / SECONDS_IN_DAY) + 1;
      }
   }
}