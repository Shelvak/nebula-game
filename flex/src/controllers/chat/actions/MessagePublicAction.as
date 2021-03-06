package controllers.chat.actions
{
   import controllers.CommunicationCommand;

   import models.chat.MChatMessage;
   import models.notification.MFaultEvent;
   import models.notification.MTimedEvent;

   import utils.locale.Localizer;

   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Processes public (channel) messages.
    * 
    * <p>
    * Client -->> Server: <code>MessagePublicActionParams</code>
    * </p>
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>pid</code> - id of a player who has sent this message</li>
    *    <li><code>msg</code> - message (up to 255 symbols)</li>
    *    <li><code>chan</code> - name of a channel this message has been sent to</li>
    * </ul>
    * </p>
    * 
    * @see MessagePublicActionParams
    */
   public class MessagePublicAction extends BaseChatAction
   {
      public function MessagePublicAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var msg:MChatMessage = MChatMessage(messagePool.borrowObject());
         msg.channel = params.chan;
         msg.playerId = params.pid;
         msg.message = params.msg;
         MCHAT.receivePublicMessage(msg);
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:MessagePublicActionParams = MessagePublicActionParams(cmd.parameters);
         var msg:MChatMessage = params.message;
         sendMessage(new ClientRMO(
            {"chan": msg.channel,
             "pid":  msg.playerId,
             "msg":  msg.message},
            null,
            msg
         ), false);
      }
      
      
      public override function result(rmo:ClientRMO) : void
      {
         MCHAT.messageSendSuccess(MChatMessage(rmo.additionalParams));
      }
      
      
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO) : void
      {
         MCHAT.messageSendFailure(MChatMessage(rmo.additionalParams));
         new MFaultEvent(Localizer.string("General", "message.actionCanceled"));
      }
   }
}