package models.chat
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   
   
   public class MChatChannelPublic extends MChatChannel
   {
      public function MChatChannelPublic(name:String)
      {
         super(name);
      }
      
      
      public override function sendMessage(message:String) : void
      {
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.playerId = ML.player.id;
         msg.playerName = ML.player.name;
         msg.channel = name;
         msg.message = message;
         new ChatCommand(ChatCommand.MESSAGE_PUBLIC, new MessagePublicActionParams(msg)).dispatch();
      }
   }
}