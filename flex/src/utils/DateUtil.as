package utils
{
   /**
    * A few static methods for working with date and time.
    */
   public class DateUtil
   {
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
         ret = helper(seconds, 60 * 60 * 24, 'days', timeString);
         ret = helper(ret[0], 60 * 60, 'hours', ret[1]);
         ret = helper(ret[0], 60, 'minutes', ret[1]);
         ret = helper(ret[0], 1, 'seconds', ret[1]);
         
         timeString = (ret[1] as String);
         if (timeString == "")
         {
            timeString = '0' + Localizer.string('General','seconds.short') + ' ';
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