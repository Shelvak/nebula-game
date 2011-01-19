package controllers.startup
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import models.BaseModel;

   public final class StartupInfo extends BaseModel
   {
      public function get port() : int
      {
         return 55345;
      }
      
      [Required]
      public var mode:String = StartupMode.GAME;
      
      [Required]
      public var server:String = "localhost";
      
      [Optional]
      public var galaxyId:int = 1;
      
      [Optional]
      public var authToken:String = "";
   }
}