package components.chat
{
   import flash.events.MouseEvent;
   
   import models.chat.events.MChatEvent;
   
   
   public class CChatOpenChanButtonMain extends CChatOpenChanButton
   {
      public function CChatOpenChanButtonMain() {
         super();
         MCHAT.addEventListener
            (MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE, model_hasUnreadMainMsgChangeHandler, false, 0, true);
         MCHAT.addEventListener
            (MChatEvent.VISIBLE_CHANGE, model_visibleChangeHandler, false, 0, true);
      }
      
      public override function get imageKeySpecificPart() : String {
         return "main";
      }
      
      
      protected override function this_clickHandler(event:MouseEvent) : void {
         if (MCHAT.visible)
            NAV_CTRL.showPreviousScreen();
         else
            NAV_CTRL.showChat();
      }
      
      protected override function getCurrentSkinState() : String {
         if (MCHAT.visible)
            return "down";
         return super.getCurrentSkinState();
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      private function model_visibleChangeHandler(event:MChatEvent) : void {
         invalidateSkinState();
      }
      
      private function model_hasUnreadMainMsgChangeHandler(event:MChatEvent) : void {
         newMessage = MCHAT.hasUnreadMainMsg;
      }
   }
}