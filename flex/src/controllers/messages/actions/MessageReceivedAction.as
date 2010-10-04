package controllers.messages.actions
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.ServerCommandsDispatcher;
   
   import flash.events.Event;
   
   import utils.DateUtil;
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Calls <code>dispatchCommand()</code> of <code>ServerCommandsDispatcher</code> for each
    * received message except for response messages. 
    */
   public class MessageReceivedAction extends AbstractAction
   {
      public override function applyAction(command:Event) : void
      {
         ServerCommandsDispatcher.getInstance().dispatchCommand(ServerRMO(MessageCommand(command).rmo));
      }
   }
}