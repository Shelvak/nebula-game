package controllers.messages.actions
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.events.Event;
   
   import utils.remote.ServerConnector;
   import utils.remote.rmo.ClientRMO;
   
   
   
   
   /**
    * Responsible for sending messages to the server as well as for notifying
    * <code>ResponseMessagesTracker</code> of new message to track. 
    */	
   public class SendMessageAction extends AbstractAction
   {
      /**
       * @private
       */
      public override function applyAction (command: Event) :void
      {
         var rmo: ClientRMO = ClientRMO (MessageCommand (command).rmo);

         ResponseMessagesTracker.getInstance().addRMO (rmo);
         ServerConnector.getInstance().sendMessage (rmo);
      }
   }
}