package controllers.chat.actions
{
   import controllers.CommunicationCommand;
   
   
   /**
    * Received from the server when a player has left a channel.
    *
    * <p> See <code>ChannelJoinAction</code> for notes about cases when this can be sent for
    * the same player.</p>
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>pid</code> - id of a player</li>
    *    <li><code>chan</code> - name of a channel</li>
    * </ul>
    * </p>
    */
   public class ChannelLeaveAction extends BaseChatAction
   {
      public function ChannelLeaveAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         MCHAT.channelLeave(params.chan, params.pid);
      }
   }
}