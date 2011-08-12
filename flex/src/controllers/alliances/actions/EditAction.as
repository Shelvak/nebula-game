package controllers.alliances.actions
{
   import components.alliance.AllianceScreenM;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Edits alliance properties
    *  
    * @author Jho
    * 
    */   
   public class EditAction extends CommunicationAction
   {
      private var allyName: String;
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         allyName = cmd.parameters.name;
         super.applyClientAction(cmd);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         AllianceScreenM.getInstance().alliance.name = allyName;
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}