package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Leaves current alliance
    *  
    * @author Jho
    * 
    */   
   public class LeaveAction extends CommunicationAction
   {
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}