package controllers.startup
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import models.BaseModel;

   public class StartupInfo extends BaseModel
   {
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