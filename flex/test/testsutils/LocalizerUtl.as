package testsutils
{
   import controllers.startup.StartupInfo;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import utils.Objects;
   import utils.locale.Locale;

   public class LocalizerUtl
   {
      private static function get RM() : IResourceManager {
         return ResourceManager.getInstance();
      }
      
      public static function setUp() : void {
         StartupInfo.getInstance().locale = Locale.EN;
      }
      
      public static function addBundle(bundleName:String, content:Object) : void {
         Objects.paramNotEquals("bundleName", bundleName, [null, ""]);
         Objects.paramNotNull("content", content);
         var rb:ResourceBundle = new ResourceBundle(Locale.currentLocale, bundleName);
         for (var key:String in content) {
            rb.content[key] = content[key];
         }
         RM.addResourceBundle(rb);
      }
      
      public static function tearDown() : void {
         RM.removeResourceBundlesForLocale(Locale.currentLocale);
      }
   }
}