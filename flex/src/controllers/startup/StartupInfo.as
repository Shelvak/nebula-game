package controllers.startup
{
   import utils.SingletonFactory;
   
   import models.BaseModel;
   
   import mx.utils.ObjectUtil;

   public final class StartupInfo extends BaseModel
   {
      public var loadSuccessful:Boolean = false;
      
      
      public function get port() : int
      {
         return 55345;
      }
      
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