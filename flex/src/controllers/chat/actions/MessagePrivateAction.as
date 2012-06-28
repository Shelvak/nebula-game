package controllers.chat.actions
{
   import controllers.CommunicationCommand;

   import models.chat.MChatMessage;
   import models.notification.MFaultEvent;
   import models.notification.MTimedEvent;

   import utils.DateUtil;
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Processes private messages.
    * 
    * <p>
    * Client -->> Server: <code>MessagePrivateActionParams</code>
    * </p>
    * 
    * <p>
    * Client <<-- Server:
    * <ul>
    *    <li><code>pid</code> - id of a player who has sent this message</li>
    *    <li><code>msg</code> - message (up to 255 symbols)</li>
    *    <li><code>name</code> - name of a player (only sent if player is not logged in)</li>
    *    <li><code>stamp</code> - time when this message was created (only sent if message was stored in DB)</li>
    * </ul>
    * </p>
    * 
    * @see MessagePrivateActionParams
    */
   public class MessagePrivateAction extends BaseChatAction
   {
      public function MessagePrivateAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         var msg:MChatMessage = MChatMessage(messagePool.borrowObject());
         msg.playerId = params.pid;
         msg.message = params.msg;
         if (params.name !== undefined)
         {
            msg.playerName = params.name;
         }
         if (params.stamp !== undefined)
         {
            msg.time = DateUtil.parseServerDTF(params.stamp);
         }
         MCHAT.receivePrivateMessage(msg);
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:MessagePrivateActionParams = MessagePrivateActionParams(cmd.parameters);
         var msg:MChatMessage = params.message;
         sendMessage(new ClientRMO(
            {"pid":  msg.playerId,
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