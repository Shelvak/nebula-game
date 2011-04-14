package components.chat
{
   import flash.events.MouseEvent;
   import flash.text.engine.FontWeight;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   import models.chat.events.MChatChannelEvent;
   
   import spark.components.Button;
   import spark.components.ButtonBarButton;
   
   
   /**
    * Button for selecting a chat channel.
    */
   public class CChatChannelTab extends ButtonBarButton
   {
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
            setFontStyle();
         }
         
         f_dataChanged = false;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_hasUnreadMessagesChangeHandler(event:MChatChannelEvent) : void
      {
         setFontStyle();
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
      
      
      private function setFontStyle() : void
      {
         var fontWeight:String = FontWeight.NORMAL;
         if (channel != null && channel.hasUnreadMessages)
         {
            fontWeight = FontWeight.BOLD;
         }
         setStyle("fontWeight", fontWeight);
      }
   }
}