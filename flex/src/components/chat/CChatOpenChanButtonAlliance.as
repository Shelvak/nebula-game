package components.chat
{
   import flash.events.MouseEvent;
   
   import models.chat.events.MChatEvent;
   
   
   public class CChatOpenChanButtonAlliance extends CChatOpenChanButton
   {
      public function CChatOpenChanButtonAlliance()
      {
         super();
         updateEnabledProperty();
//         toolTip = getString("tooltip.allianceChannel");
         MCHAT.addEventListener(
            MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE,
            model_hasUnreadAllianceMsgChangeHandler
         );
         MCHAT.addEventListener(
            MChatEvent.ALLIANCE_CHANNEL_OPEN_CHANGE,
            model_allianceChannelOpenChangeHandler
         );
      }
      
      
      public override function get imageKeySpecificPart() : String
      {
         return "alliance";
      }
      
      
      protected override function this_clickHandler(event:MouseEvent) : void
      {
         super.this_clickHandler(event);
         MCHAT.selectAllianceChannel();
      }
      
      
      private function updateEnabledProperty() : void
      {
         enabled = MCHAT.allianceChannelOpen;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_hasUnreadAllianceMsgChangeHandler(event:MChatEvent) : void
      {
         newMessage = MCHAT.hasUnreadAllianceMsg;
      }
      
      
      private function model_allianceChannelOpenChangeHandler(event:MChatEvent) : void
      {
         updateEnabledProperty();
      }
   }
}