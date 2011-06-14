package utils
{
   import config.Config;
   
   import controllers.startup.StartupInfo;
   
   import flash.net.URLRequest;
   import flash.net.navigateToURL;

   public class UrlNavigate
   {
      public static function getInstance(): UrlNavigate
      {
         return SingletonFactory.getSingletonInstance(UrlNavigate);
      }
      
      private function get wikiUrlRoot(): String
      {
         return 'http://wiki.' + StartupInfo.getInstance().webHost + '/index.php/';
      }
      
      public function get urlRoot(): String
      {
         return 'http://' + StartupInfo.getInstance().webHost + '/';
      }
      
      public function getTipImageUrl(tipId:int) : String
      {
         return urlRoot + "tips/" + tipId;
      }
      
      public function showUrl(path: String): void
      {
         navigateToURL(new URLRequest(urlRoot + path));
      }
      
      public function showWikiUrl(path: String): void
      {
         navigateToURL(new URLRequest(wikiUrlRoot + path));
      }
      
      public function showBuyCreds(): void
      {
         showUrl('buy-creds');
      }
   }
}