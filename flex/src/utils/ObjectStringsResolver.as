package utils
{
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   
   public class ObjectStringsResolver
   {
      public static function getString(type: String, count: int): String
      {
         var minNumber: int = getMin(count);
         var rString: String = Localizer.string('Objects', type+minNumber);
         if (rString == null)
         {
            throw new Error("Object "+type+" count "+minNumber+" not found");
         }
         return rString;
      }
      
      private static function getMin(current: int): int
      {
         switch (Locale.currentLocale)
         {
            case Locale.EN:
               if (current > 1)
               {
                  return 2;
               }
               else
               {
                  return 1;
               }
               break;
         }
         return 0;
      }
   }
}