package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   
   
   /**
    * Informs the server that a player has seen first time login screen and open up quests window from
    * there or changed portalWithoutAllies property.
    */
   public class EditAction extends CommunicationAction
   {
      public function EditAction()
      {
         super();
      }
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         if (cmd.parameters == null)
         {
            sendMessage(new ClientRMO({"firstTime": false}));
         }
         else
         {
            super.applyClientAction(cmd);
         }
      }
      
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