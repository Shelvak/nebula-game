package utils
{
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceManager;

   public class Localizer
   {
      private static const REFERENCE_REGEXP: RegExp = /\[reference:((\w+)\/)?(.+?)\]/;
      
      private static var currentBundle: String;
      
      private static function refReplace(matchedString: String, unused: String, bundleName: String, 
                                         propertyName: String, matchPosition: int, 
                                         completeString: String): String
      {
         var bundle: String = bundleName ? bundleName : currentBundle;
         return string(bundle, propertyName);
      }
      
      public static function string(bundle: String, property: String, parameters: Array = null): String
      {
         var resultString: String = ResourceManager.getInstance().getString(bundle, property, parameters);
         var matches:Array = resultString.match(REFERENCE_REGEXP);
         while (matches != null)
         {
            currentBundle = bundle;
            resultString = resultString.replace(REFERENCE_REGEXP, refReplace);
            matches = resultString.match(REFERENCE_REGEXP);
         }
         
         return resultString;
      }
      
      public static function get localeChain(): Array
      {
         return ResourceManager.getInstance().localeChain;
      }
      
      public static function addBundle(bundle: IResourceBundle): void
      {
         ResourceManager.getInstance().addResourceBundle(bundle);
         ResourceManager.getInstance().update();
      }
   }
}