package controllers.messages.actions
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.events.Event;
   
   import utils.remote.ServerProxyInstance;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Responsible for sending messages to the server as well as for notifying
    * <code>ResponseMessagesTracker</code> of new message to track. 
    */	
   public class SendMessageAction extends AbstractAction
   {
      public override function applyAction(command:Event) :void
      {
         var rmo:ClientRMO = ClientRMO(MessageCommand(command).rmo);
         ResponseMessagesTracker.getInstance().addRMO(rmo);
         ServerProxyInstance.getInstance().sendMessage(rmo);
      }
   }
}