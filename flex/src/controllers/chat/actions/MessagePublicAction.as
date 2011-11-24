package controllers.chat.actions
{
   import controllers.CommunicationCommand;
   import controllers.Messenger;

   import models.chat.MChatMessage;

   import utils.locale.Localizer;

   import utils.remote.rmo.ClientRMO;
   
   
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
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         MCHAT.messageSendFailure(MChatMessage(rmo.additionalParams));
         Messenger.show(Localizer.string("General", "message.actionCanceled"),
                 Messenger.MEDIUM);
      }
   }
}