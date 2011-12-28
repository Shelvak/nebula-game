package utils.locale
{
   import controllers.startup.StartupInfo;

   /**
    * Defines all supported locales.
    */
   public final class Locale
   {
      /**
       * A locale for testing. Don't use other locales in tests.
       */
      public static const TEST:String = "test";
      public static const EN:String = "en";
      public static const LT:String = "lt";
      public static const LV:String = "lv";
      
      
      /**
       * Current locale in effect (shortcut to <code>StartupInfo.locale</code>).
       */
      public static function get currentLocale() : String
      {
         return StartupInfo.getInstance().locale;
      }
   }
}