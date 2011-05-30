package utils
{
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   
   public class ObjectStringsResolver
   {
      public static function getString(type: String, form: String, count: int): String
      {
         var rString: String = Localizer.string('Objects', type+'-'+form, [count]);
         if (rString == null)
         {
            throw new Error("Object "+type+'-'+form+" count "+count+" not found");
         }
         return rString;
      }
   }
}