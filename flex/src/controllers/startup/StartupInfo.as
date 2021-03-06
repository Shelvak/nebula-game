package controllers.startup
{
   import controllers.players.MultiAccountController;

   import models.BaseModel;
   
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;
   import utils.locale.Locale;
   
   
   public final class StartupInfo extends BaseModel
   {
      /**
       * Should client ignore some of server objects/chat messages during startup that would
       * otherwise cause client to crash if handled like in normal app execution?
       *
       * This includes messages like objects|update or chat|join that according to the server should
       * be processed before those objects are created or before chat is initialized and so on.
       */
      public static function get relaxedServerMessagesHandlingMode(): Boolean {
         return !getInstance().initializationComplete;
      }

      public static function getInstance() : StartupInfo {
         return SingletonFactory.getSingletonInstance(StartupInfo);
      }

      public var MACheck: MultiAccountController;

      public var loadSuccessful: Boolean = false;
      public var initializationComplete: Boolean = false;
      
      
      public function get port() : int {
         return 55345;
      }

      public var playerLoaded: Boolean = false;
      
      [Required]
      public var locale:String = Locale.EN;
      
      [Required]
      public var mode:String = StartupMode.GAME;
      
      [Required]
      public var server:String = "localhost";
      
      [Optional]
      public var assetsUrl:String = "";
      
      [Optional]
      public var webHost:String = "localhost";
      
      [Optional]
      public var logId:String = "";
      
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
      public var unbundledAssetsSums:Object;
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String {
         return ObjectUtil.toString(this);
      }
   }
}