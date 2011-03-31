package controllers.chat.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Processes public (channel) messages.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>message</code> - an instance of <code>MChatMessage</code> with <code>playerId</code> and
    *        <code>message</code> (up to 255 symbols) properties set. Other properties will not be
    *        used. The instance must have been borrowed from the <code>MChat.messagePool</code> pool and must
    *        be returned to the pool once it is no longer needed.</li>
    * </ul>
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
    */
   public class MessagePublicAction extends CommunicationAction
   {
      public function MessagePublicAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         
      }
      
      
      public override function result(rmo:ClientRMO) : void
      {
         
      }
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
      }
   }
}