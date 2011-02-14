package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.BaseModel;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Stops the squadron in its current position.
    * 
    * <p>You can either pass <code>MSquadron</code> or <code>MRoute</code> as <code>cmd.parameters</code>
    * for this controller but <code>MSquadron</code> should be preffered at all times.</p>
    */
   public class DestroyAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         var model:BaseModel = BaseModel(cmd.parameters);
         sendMessage(new ClientRMO({"id": model.id}, model));
      }
   }
}