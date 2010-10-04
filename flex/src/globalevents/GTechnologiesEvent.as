package globalevents
{
   public class GTechnologiesEvent extends GlobalEvent
   {
      public static const TECHNOLOGIES_CREATED: String = "techsCreated";
      
      public static const TECHNOLOGY_LEVEL_CHANGED: String = "techLvlChange";
      
      public static const UPGRADE_APPROVED: String = "technologyUpgradeApproved";
	  
	  public static const UPDATE_APPROVED: String = "technologyUpdateApproved";
     
     public static const PAUSE_APPROVED: String = "technologyPauseApproved";
      
      public function GTechnologiesEvent(type:String, eagerDispatch:Boolean=true)
      {
         super(type, eagerDispatch);
      }
   }
}