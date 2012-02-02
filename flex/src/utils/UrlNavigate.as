package utils
{
   import controllers.startup.StartupInfo;

   import flash.net.URLRequest;
   import flash.net.navigateToURL;

   import utils.locale.Locale;


   public class UrlNavigate
   {
      public static function getInstance(): UrlNavigate {
         return SingletonFactory.getSingletonInstance(UrlNavigate);
      }

      private function get SI(): StartupInfo {
         return StartupInfo.getInstance();
      }

      public function getWikiUrlRoot(): String {
         return 'http://wiki.' + SI.webHost + '/index.php/';
      }

      private function get unbundledAssetsUrlRoot(): String {
         return SI.assetsUrl + "assets/unbundled/";
      }

      public function get urlRoot(): String {
         return 'http://' + StartupInfo.getInstance().webHost + '/';
      }

      private function getUnbundledAssetUrl(relativePath:String,
                                            includeLocale:Boolean): String {
         var url:String = relativePath;
         if (includeLocale) {
            url = url.replace(/(\w+\.\w+$)/, Locale.currentLocale + "_$1");
         }
         if (SI.unbundledAssetsSums != null) {
            url = SI.unbundledAssetsSums[url];
         }
         return unbundledAssetsUrlRoot + url;
      }

      /**
       * @param relativePath path to the image relative to unbundled images
       * base URL.
       * <p>For example suppose you need URL of an image located at
       * [http://nebula-domain.com/assets/unbundled/images/quests/MainQuest.jpg].
       * The relative path to this image you need to provide to this method
       * is [quests/MainQuest.jpg]
       * </p>
       * @param includeLocale should a current locale be included when building URL
       * 
       * @return full URL of an unbundled image with locale string included in
       * the name if requested. Checksum is also included in the returned URL.
       */
      public function getUnbundledImageUrl(relativePath:String,
                                           includeLocale:Boolean = false): String {
         return getUnbundledAssetUrl("images/" + relativePath, includeLocale);
      }

      public function showUrl(path: String): void {
         navigateToURL(new URLRequest(urlRoot + path));
      }

      public function openApocalypseInfo(): void {
         navigateToURL(new URLRequest(getWikiUrlRoot() + 'apocalypse'));
      }

      public function showWikiUrl(path: String): void {
         navigateToURL(new URLRequest(getWikiUrlRoot() + path));
      }

      public function showInviteFriendUrl(): void {
         showUrl('invite-referral');
      }

      public function showBuyCreds(): void {
         showUrl('buy-creds');
      }

      public function showInfo(name: String): void {
         showUrl('info/' + name);
      }
   }
}
