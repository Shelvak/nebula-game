package controllers.messages.actions
{
   import com.developmentarc.core.actions.actions.AbstractAction;
   
   import controllers.CommunicationCommand;
   import controllers.messages.MessageCommand;
   
   import flash.events.Event;
   
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Calls <code>dispatchCommand()</code> of <code>ServerCommandsDispatcher</code> for each
    * received message except for response messages. 
    */
   public class MessageReceivedAction extends AbstractAction
   {
      public override function applyAction(command:Event) : void
      {
         var rmo:ServerRMO = ServerRMO(MessageCommand(command).rmo);
         new CommunicationCommand(rmo.action, rmo.parameters, true, false, rmo).dispatch();
      }
   }
}