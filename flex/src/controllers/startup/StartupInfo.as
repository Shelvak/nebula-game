package controllers.startup
{
   import models.BaseModel;
   import models.events.StartupEvent;
   
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;
   import utils.locale.Locale;
   
   
   public final class StartupInfo extends BaseModel
   {
      public static function getInstance() : StartupInfo {
         return SingletonFactory.getSingletonInstance(StartupInfo);
      }
      
      
      public var loadSuccessful:Boolean = false;
      
      
      public function get port() : int {
         return 55345;
      }
      
      [Required]
      public var locale:String = Locale.EN;
      
      [Required]
      public var mode:String = StartupMode.GAME;
      
      [Required]
      public var server:String = "localhost";
      
      [Optional]
      public var assetsUrl:String = "";
      
      [Optional]
      public var webHost:String;      
      
      [Optional]
      public var logId:String = "";
      
      [Optional]
      public var galaxyId:int = 1;
      
      [Optional]
      /**
       * Used only for combat replays.
       */
      public var playerId:int = 0;
      
      [Optional]
      public var webPlayerId:int = 0;
      
      [Optional]
      public var serverPlayerId:int = 0;
      
      public var assetsSums:Object;
      
      public var localeSums:Object;
      
      private var _checksumsDownloaded: Boolean = false;
      public function get checksumsDownloaded() : Boolean {
         return _checksumsDownloaded;
      }      
      
      public function handleChecksumsDownloaded() : void {
         _checksumsDownloaded = true;
         dispatchSimpleEvent(StartupEvent, StartupEvent.CHECKSUMS_DOWNLOADED);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String {
         return ObjectUtil.toString(this);
      }
   }
}