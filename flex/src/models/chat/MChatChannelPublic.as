package models.chat
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   
   import utils.locale.Localizer;
   
   
   public class MChatChannelPublic extends MChatChannel
   {
      public function MChatChannelPublic(name:String)
      {
         super(name);
      }
      
      
      /**
       * Name of the public channel to be displayed for the user.
       */
      public override function get displayName() : String
      {
         if (isMain)
         {
            return getString("label.mainChannel");
         }
         if (isAlliance)
         {
            return getString("label.allianceChannel");
         }
         return name;
      }
      
      
      /**
       * <code>true</code> if this channel is an alliance channel.
       */
      public function get isAlliance() : Boolean
      {
         return name.indexOf(MChat.ALLIANCE_CHANNEL_PREFIX) == 0;
      }
      
      
      /**
       * <code>true</code> if this channel is the main (galaxy) channel.
       */
      public function get isMain() : Boolean
      {
         return name == MChat.MAIN_CHANNEL_NAME;
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
      
      
      private function getString(property:String) : String
      {
         return Localizer.string("Chat", property);
      }
   }
}