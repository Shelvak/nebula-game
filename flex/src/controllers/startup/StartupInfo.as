package controllers.startup
{
   import models.BaseModel;
   import models.events.StartupEvent;
   
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;
   import utils.locale.Locale;
   
   
   public final class StartupInfo extends BaseModel
   {
      public static function getInstance() : StartupInfo
      {
         return SingletonFactory.getSingletonInstance(StartupInfo);
      }
      
      
      public var loadSuccessful:Boolean = false;
      
      
      public function get port() : int
      {
         return 55345;
      }
      
      [Required]
      public var locale:String = Locale.EN;
      
      [Required]
      public var mode:String = StartupMode.GAME;
      
      [Required]
      public var server:String = "localhost";
      
      [Optional]
      public var webHost:String;
      
      [Optional]
      public var logId:String = "";
      
      [Optional]
      public var galaxyId:int = 1;
      
      [Optional]
      public var authToken:String = "";
      
      [Optional]
      public var playerId:int = 0;
      
      public var assetsSums: Object;
      
      public var localeSums: Object;
      
      public function get checksumsDownloaded(): Boolean
      {
         return _checksumsDownloaded;
      }
      
      private var _checksumsDownloaded: Boolean = false;
      
      public function handleChecksumsDownloaded(): void
      {
         _checksumsDownloaded = true;
         if (hasEventListener(StartupEvent.CHECKSUMS_DOWNLOADED))
         {
            dispatchEvent(new StartupEvent(StartupEvent.CHECKSUMS_DOWNLOADED));
         }
      }
      
      public override function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}