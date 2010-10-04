package utils
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle ('Objects')]
   
   public class ObjectStringsResolver
   {
      private static var RM: IResourceManager = ResourceManager.getInstance();
      
      public static function getString(type: String, count: int): String
      {
         var minNumber: int = getMin(count);
         var rString: String = RM.getString('Objects', type+minNumber);
         if (rString == null)
         {
            throw new Error("Object "+type+" count "+minNumber+" not found");
         }
         return rString;
      }
      
      private static function getMin(current: int): int
      {
         switch (RM.localeChain[0])
         {
            case "en_US":
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