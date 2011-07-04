package components.chat
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import models.chat.events.MChatEvent;
   
   
   public class CChatOpenChanButtonMain extends CChatOpenChanButton
   {
      public function CChatOpenChanButtonMain() {
         super();
//         toolTip = getString("tooltip.mainChannel");
         MCHAT.addEventListener(
            MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE,
            model_hasUnreadMainMsgChangeHandler
         );
      }
      
      public override function get imageKeySpecificPart() : String {
         return "main";
      }
      
      
      protected override function this_clickHandler(event:MouseEvent) : void {
         super.this_clickHandler(event);
         MCHAT.selectMainChannel();
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_hasUnreadMainMsgChangeHandler(event:MChatEvent) : void {
         newMessage = MCHAT.hasUnreadMainMsg;
      }
   }
}