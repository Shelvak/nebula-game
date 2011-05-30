package controllers.startup
{
   import models.BaseModel;
   
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;

   public final class StartupInfo extends BaseModel
   {
      public var loadSuccessful:Boolean = false;
      
      
      public function get port() : int
      {
         return 55345;
      }
      
      [Required]
      public var locale:String = "en_US";
      
      [Required]
      public var mode:String = StartupMode.GAME;
      
      [Required]
      public var server:String = "localhost";
      
      [Optional]
      public var logId:String = "";
      
      [Optional]
      public var galaxyId:int = 1;
      
      [Optional]
      public var authToken:String = "";
      
      [Optional]
      public var playerId:int = 0;
      
      
      public override function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}