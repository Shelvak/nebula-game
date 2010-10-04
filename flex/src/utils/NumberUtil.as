package utils
{
   public class NumberUtil
   {
      public static function addLeadingZeros(number:int, characters:int) : String
      {
         if (number < 0 || characters < 0)
         {
            throw new ArgumentError("[param number] and [param characters] can't be negative");
         }
         var numString:String = number.toString();
         if (numString.length >= characters)
         {
            return numString;
         }
         var zeros:String = "";
         for (var i:int = 0; i < characters - numString.length; i++)
         {
            zeros += "0";
         }
         return zeros + numString;
      }
   }
}