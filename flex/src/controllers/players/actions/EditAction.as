package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import utils.remote.rmo.ClientRMO;
   
   
   
   /**
    * Informs the server that a player has seen first time login screen and open up quests window from
    * there.
    */
   public class EditAction extends CommunicationAction
   {
      public function EditAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         sendMessage(new ClientRMO({"firstTime": false}));
      }
   }
}