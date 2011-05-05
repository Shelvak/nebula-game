package utils
{
   import mx.utils.ObjectUtil;
   
   
   public final class NumberUtil
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
      
      
      /**
       * Compares two given floating point numbers. The numbers are considered equal if difference between
       * them is less than the given epsilon value.
       * 
       * @return <code>-1</code> if <code>value1 &lt; value2</code>, <code>+1</code> if <code>value1 &gt;
       * value2</code> or <code>0</code> if <code>value1 == value2</code>
       */
      public static function compareFloat(value1:Number, value2:Number, epsilon:Number = 0) : int
      {
         if (Math.abs(value1 - value2) < epsilon)
         {
            return 0;
         }
         return value1 < value2 ? -1 : 1;
      }
      
      
      /**
       * Compares two given numbers (of any type).
       *  
       * @return <code>-1</code> if <code>value1 < value2</code>, <code>+1</code> if <code>value1 >
       * value2</code> or <code>0</code> if <code>value1 == value2</code>
       */      
      public static function compare(value0:Number, value1:Number) : int
      {
         return ObjectUtil.numericCompare(value0, value1);
      }
      
      
      /**
       * Checks if <code>value1</code> is less than <code>value2</code>.
       * 
       * @see #compare()
       */
      public static function lessThan(value1:Number, value2:Number, epsilon:Number = 0) : Boolean
      {
         return compareFloat(value1, value2, epsilon) < 0;
      }
      
      
      /**
       * Checks if <code>value1</code> is greater than <code>value2</code>.
       * 
       * @see #compare()
       */
      public static function greaterThan(value1:Number, value2:Number, epsilon:Number = 0) : Boolean
      {
         return compareFloat(value1, value2, epsilon) > 0;
      }
      
      
      /**
       * Checks if <code>value1</code> and <code>value2</code> are equal.
       * 
       * @see #compare()
       */
      public static function equal(value1:Number, value2:Number, epsilon:Number = 0) : Boolean
      {
         return compareFloat(value1, value2, epsilon) == 0;
      }
   }
}