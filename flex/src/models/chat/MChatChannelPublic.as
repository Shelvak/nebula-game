package models.chat
{
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   import controllers.sounds.SoundsController;

   import models.player.PlayerOptions;

   import models.time.MTimeEventFixedMoment;

   import utils.locale.Localizer;
   
   
   public class MChatChannelPublic extends MChatChannel
   {
      public function MChatChannelPublic(name:String)
      {
         super(name);
      }

      public override function receiveMessage (message: MChatMessage): void
      {
         super.receiveMessage(message);
         if (isAlliance && !visible
            && PlayerOptions.soundForAllianceMsg != PlayerOptions.NO_SOUND)
         {
            SoundsController.
               fetchNotification(PlayerOptions.soundForAllianceMsg).play();
         }
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
       * Returns <code>true</code>.
       */
      public override function get isPublic() : Boolean {
         return true;
      }
      
      /**
       * <code>true</code> if this channel is an alliance channel.
       */
      public function get isAlliance() : Boolean
      {
         return name.indexOf(MChat.ALLIANCE_CHANNEL_PREFIX) == 0;
      }


      private const _neverSilenced: MTimeEventFixedMoment = new MTimeEventFixedMoment();
      override public function get silenced(): MTimeEventFixedMoment {
         return isAlliance ? _neverSilenced : super.silenced;
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
         msg.playerId = player.id;
         msg.playerName = player.name;
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