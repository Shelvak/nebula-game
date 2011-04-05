package models.chat.message.processors
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   
   import models.chat.MChatMessage;
   
   
   /**
    * Knows how to receive and send public channel messages.
    */
   public class PublicMessageProcessor extends ChatMessageProcessor
   {
      public function PublicMessageProcessor()
      {
         super();
      }
      
      
      public override function sendMessage(message:String) : void
      {
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.playerId = ML.player.id;
         msg.playerName = ML.player.name;
         msg.channel = channel.name;
         msg.message = message;
         new ChatCommand(ChatCommand.MESSAGE_PUBLIC, new MessagePublicActionParams(msg)).dispatch();
      }
   }
}