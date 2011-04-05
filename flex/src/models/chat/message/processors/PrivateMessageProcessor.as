package models.chat.message.processors
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   
   
   /**
    * Knows how to send and receive messages in a private channel.
    */
   public class PrivateMessageProcessor extends ChatMessageProcessor
   {
      public function PrivateMessageProcessor()
      {
         super();
      }
      
      
      public override function sendMessage(message:String) : void
      {
         /**
          * Recipient lookup.
          * Private channel has only two members: one is the player and another is his/her friend.
          * However, I don't know who is first in the list so have to check both of them.
          */
         var member:MChatMember = MChatMember(channel.members.getItemAt(0));
         if (member.id == ML.player.id)
         {
            // Friend is second.
            member = MChatMember(channel.members.getItemAt(1));
         }
         
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.message = message;
         msg.playerId = member.id;
         
         new ChatCommand(ChatCommand.MESSAGE_PRIVATE, new MessagePrivateActionParams(msg)).dispatch();
      }
      
      
      public override function messageSendSuccess(message:MChatMessage) : void
      {
         message.playerId = ML.player.id;
         message.playerName = ML.player.name;
         message.time = new Date();
         super.messageSendSuccess(message);
      }
   }
}