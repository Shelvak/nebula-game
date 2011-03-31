package controllers.chat.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   
   /**
    * Notifies client about another player joining a channel.
    * 
    * <p>This can be pushed for same player too if it is issued as a part of some third part action like
    * changing the alliance. In that case  a new tab should be opened in client for this channel because
    * client is now joined to that channel.</p>
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>pid</code> - id of a player</li>
    *    <li><code>name</code> - name of a player</li>
    *    <li><code>chan</code> - name of a channel</li>
    * </ul>
    * </p>
    */
   public class ChannelJoinAction extends CommunicationAction
   {
      public function ChannelJoinAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         
      }
   }
}