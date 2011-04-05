package models.chat
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import utils.locale.Localizer;
   
   
   public class MChatChannelPrivate extends MChatChannel
   {
      public function MChatChannelPrivate(name:String)
      {
         super(name);
      }
      
      
      /**
       * Combination of text from "Chat" bundle and <code>name</code>.
       */
      public override function get displayName() : String
      {
         return Localizer.string("Chat", "label.privateChannel", [name]);
      }
      
      
      public override function sendMessage(message:String) : void
      {
         /**
          * Recipient lookup.
          * Private channel has only two members: one is the player and another is his/her friend.
          * However, I don't know who is first in the list so have to check both of them.
          */
         var member:MChatMember = MChatMember(members.getItemAt(0));
         if (member.id == ML.player.id)
         {
            // Friend is second.
            member = MChatMember(members.getItemAt(1));
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