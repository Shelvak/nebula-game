package components.chat
{
   import flash.events.MouseEvent;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.events.MChatChannelEvent;
   
   import spark.components.Button;
   import spark.components.ButtonBarButton;
   import spark.components.Group;
   import spark.filters.GlowFilter;
   
   
   /**
    * Component enters this state if there is at least one unread message in the chat.
    */
   [SkinState("newMessage")]
   
   
   /**
    * Button for selecting a chat channel.
    */
   public class CChatChannelTab extends ButtonBarButton
   {
      private static const SKIN_STATE_NEW_MESSAGE:String = "newMessage";
      
      
      public function CChatChannelTab()
      {
         super();
         setStyle("skinClass", CChatChannelTabSkin);
         mouseChildren = true;
         
         // for some reason handler registered on btnClose is not called
         addEventListener(MouseEvent.CLICK, this_clickHandler, true, 0, true);
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function this_clickHandler(event:MouseEvent) : void
      {
         if (event.target == btnClose)
         {
            event.stopImmediatePropagation();
            closeChannel();
         }
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * Used for closing the channel.
       */
      public var btnClose:Button;
      
      
      protected override function getCurrentSkinState() : String
      {
         if (channel != null && channel.hasUnreadMessages)
         {
            return SKIN_STATE_NEW_MESSAGE;
         }
         return super.getCurrentSkinState();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _channelOld:MChatChannel = null;
      public override function set data(value:Object) : void
      {
         if (super.data != value)
         {
            if (_channelOld == null)
            {
               _channelOld = channel;
            }
            super.data = value;
            f_dataChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_dataChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_dataChanged)
         {
            if (_channelOld != null)
            {
               _channelOld.removeEventListener(
                  MChatChannelEvent.HAS_UNREAD_MESSAGES_CHANGE,
                  model_hasUnreadMessagesChangeHandler, false
               );
               _channelOld = null;
            }
            if (channel != null)
            {
               channel.addEventListener(
                  MChatChannelEvent.HAS_UNREAD_MESSAGES_CHANGE,
                  model_hasUnreadMessagesChangeHandler, false, 0, true
               );
            }
            btnClose.visible = channel != null && channel is MChatChannelPrivate;
            invalidateSkinState();
         }
         
         f_dataChanged = false;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_hasUnreadMessagesChangeHandler(event:MChatChannelEvent) : void
      {
         invalidateSkinState();
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      
      /**
       * Typed alias for <code>data</code> property.
       */
      private function get channel() : MChatChannel
      {
         return MChatChannel(super.data);
      }
      
      
      /**
       * Closes the channel associated with this button.
       */
      private function closeChannel() : void
      {
         MChat.getInstance().closePrivateChannel(channel.name);
      }
   }
}