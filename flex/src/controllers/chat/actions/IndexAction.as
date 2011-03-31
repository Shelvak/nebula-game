package controllers.chat.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   
   /**
    * Server sends this to initialize the chat.
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>players</code> - a hash of players in the chat of the form <code>{pid => pname}</code></li>
    *    <li><code>channels</code> - a hash of all available channels of the form
    *        <code>{cname => [pid, pid, ...]}</code></li>
    * </ul>
    * Here:
    * <ul>
    *    <li><code>pid</code> - id of a player</li>
    *    <li><code>pname</code> - name of a player</li>
    *    <li><code>cname</code> - name of a channel</li>
    * </ul>
    * </p>
    */
   public class IndexAction extends CommunicationAction
   {
      public function IndexAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         
      }
   }
}