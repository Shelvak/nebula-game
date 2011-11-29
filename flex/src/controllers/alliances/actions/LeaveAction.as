package controllers.alliances.actions
{
   import components.alliance.AllianceScreenM;

   import controllers.CommunicationAction;

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
         super.result(rmo);
         AllianceScreenM.getInstance().alliance = null;
      }
   }
}