package components.chat
{
   import flash.events.MouseEvent;
   
   import models.chat.events.MChatEvent;
   
   
   public class CChatOpenChanButtonPrivate extends CChatOpenChanButton
   {
      public function CChatOpenChanButtonPrivate()
      {
         super();
         updateEnabledProperty();
//         toolTip = getString("tooltip.privateChannel");
         MCHAT.addEventListener(
            MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE,
            model_hasUnreadPrivateMsgChangeHandler
         );
         MCHAT.addEventListener(
            MChatEvent.PRIVATE_CHANNEL_OPEN_CHANGE,
            model_privateChannelOpenChangeHandler
         );
      }
      
      
      public override function get imageKeySpecificPart() : String
      {
         return "private";
      }
      
      
      protected override function this_clickHandler(event:MouseEvent) : void
      {
         super.this_clickHandler(event);
         MCHAT.selectFirstPrivateChannel();
      }
      
      
      private function updateEnabledProperty() : void
      {
         enabled = MCHAT.privateChannelOpen;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_hasUnreadPrivateMsgChangeHandler(event:MChatEvent) : void
      {
         newMessage = MCHAT.hasUnreadPrivateMsg;
      }
      
      
      private function model_privateChannelOpenChangeHandler(event:MChatEvent) : void
      {
         updateEnabledProperty();
      }
   }
}