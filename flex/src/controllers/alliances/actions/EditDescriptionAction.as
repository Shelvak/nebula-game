package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.alliance.MAlliance;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;

   /**
    * Edits alliance description
    *  
    * @author Jho
    * 
    */   
   public class EditDescriptionAction extends CommunicationAction
   {
      private var alliance: MAlliance;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         alliance = MAlliance(cmd.parameters);
         sendMessage(
            new ClientRMO(
               {"description": alliance.newDescription}
            )
         );
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         alliance.description = alliance.newDescription;
         alliance = null;
      }
      
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO):void
      {
         super.cancel(rmo, srmo);
         alliance.newDescription = alliance.description;
         alliance = null;
      }
   }
}