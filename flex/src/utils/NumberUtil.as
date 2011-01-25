package utils
{
   public class NumberUtil
   {
      private static const BILLION: int = 1000000000;
      private static const MILLION: int = 1000000;
      private static const THOUSAND: int = 1000;
      
      private static const BILLION_SUFFIX: String = 'g';
      private static const MILLION_SUFFIX: String = 'm';
      private static const THOUSAND_SUFFIX: String = 'k';
      
      /**
       * Returns short representation of given number, rounded to precision.
       * 
       * Example:
       *    NumberUtil.toShortString(10.552, 2) => "10.55"
       *    NumberUtil.toShortString(1552, 2) => "1.55k"
       *    NumberUtil.toShortString(1552000, 2) => "1.55m"
       *    NumberUtil.toShortString(1552000000, 2) => "1.55g"
       * 
       **/ 
      public static function toShortString(number: Number, roundingPrecision: int=1): String
      {
         var rounder: int = 10 * roundingPrecision;
         var divider: int = 1;
         var suffix: String = '';
         
         var absNumber: Number = Math.abs(number);
         if (absNumber >= BILLION) {
            divider = BILLION;
            suffix = BILLION_SUFFIX;
         }
         else if (absNumber >= MILLION) {
            divider = MILLION;
            suffix = MILLION_SUFFIX;
         }
         else if (absNumber >= THOUSAND) {
            divider = THOUSAND;
            suffix = THOUSAND_SUFFIX;
         }
         
         return (Math.round(number / divider * rounder) / rounder).toString() + suffix
      }
   }
}