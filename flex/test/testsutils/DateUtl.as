package testsutils
{
   public class DateUtl
   {
      public static function createUTC(year:* = null,
                                       month:* = null,
                                       date:* = null,
                                       hours:* = null,
                                       minutes:* = null,
                                       seconds:* = null) : Date {
         var value:Date = new Date(0);
         value.setUTCFullYear(year, month, date);
         value.setUTCHours(hours, minutes, seconds);
         return value;
      }
   }
}