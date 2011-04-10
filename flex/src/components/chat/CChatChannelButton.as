package components.chat
{
   import flash.events.MouseEvent;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   
   import spark.components.Button;
   import spark.components.ButtonBarButton;
   
   
   /**
    * Button for selecting a chat channel.
    */
   public class CChatChannelButton extends ButtonBarButton
   {
      public function CChatChannelButton()
      {
         super();
         setStyle("skinClass", CChatChannelButtonSkin);
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
      
      
      public override function set data(value:Object) : void
      {
         if (super.data != value)
         {
            super.data = value;
            
         }
      }
      
      
      private var f_dataChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_dataChanged)
         {
            btnClose.visible = channel != null && channel is MChatChannelPrivate;
         }
         
         f_dataChanged = false;
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      
      private function get channel() : MChatChannel
      {
         return MChatChannel(data);
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