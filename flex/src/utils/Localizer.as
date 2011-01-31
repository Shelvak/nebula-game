package utils
{
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceManager;
   
   
   [ResourceBundle("BattleMap")]
   [ResourceBundle("Buildings")]
   [ResourceBundle("BuildingSelectedSidebar")]
   [ResourceBundle("BuildingSidebar")]
   [ResourceBundle("Exploration")]
   [ResourceBundle("Formatters")]
   [ResourceBundle("General")]
   [ResourceBundle("InfoScreen")]
   [ResourceBundle("LoadingScreen")]
   [ResourceBundle("Location")]
   [ResourceBundle("MainMenu")]
   [ResourceBundle("MapViewportControls")]
   [ResourceBundle("Movement")]
   [ResourceBundle("Navigator")]
   [ResourceBundle("Notifications")]
   [ResourceBundle("Objects")]
   [ResourceBundle("Players")]
   [ResourceBundle("Popups")]
   [ResourceBundle("Quests")]
   [ResourceBundle("Ratings")]
   [ResourceBundle("Resources")]
   [ResourceBundle("SpinnerContainer")]
   [ResourceBundle("Squadrons")]
   [ResourceBundle("SSObjects")]
   [ResourceBundle("Technologies")]
   [ResourceBundle("Units")]
   [ResourceBundle("Galaxy")]
   [ResourceBundle("WelcomeScreen")]
   
   
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
         if (resultString == null)
         {
            throw new Error('Resource ' + property + ' for bundle ' + bundle + ' not found!');
         }
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