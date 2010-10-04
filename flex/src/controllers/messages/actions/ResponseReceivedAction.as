package controllers.messages.actions
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.events.Event;
   
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Called when response message has been received from the server: notifies
    * <code>ResponseMessagesTracker</code> about it.
    */	
   public class ResponseReceivedAction extends AbstractAction
   {
      /**
       * @private  
       */
      public override function applyAction (command: Event) :void
      {
         ResponseMessagesTracker.getInstance().removeRMO(ServerRMO(MessageCommand(command).rmo));
      }
   }
}