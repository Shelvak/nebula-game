package components.chat
{
   import controllers.ui.NavigationController;
   
   import flash.events.MouseEvent;
   
   import models.chat.MChat;
   import models.chat.events.MChatEvent;
   
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.ToggleButton;
   import spark.layouts.HorizontalLayout;
   
   import utils.locale.Localizer;
   
   
   /**
    * Groups three chat sub-buttons: main, alliance and private channel. 
    */
   public class CChatOpenChanButtons extends Group
   {
      private function get NAV_CTRL() : NavigationController
      {
         return NavigationController.getInstance();
      }
      
      
      private function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      public function CChatOpenChanButtons()
      {
         super();
         mouseEnabled = false;
         
         MCHAT.addEventListener(
            MChatEvent.ALLIANCE_CHANNEL_OPEN_CHANGE, model_allianceChannelOpenChangeHandler, false, 0, true
         );
         MCHAT.addEventListener(
            MChatEvent.PRIVATE_CHANNEL_OPEN_CHANGE, model_privateChannelOpenChangeHandler, false, 0, true
         );
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      /**
       * Opens the main channel.
       */
      private var btnMainChannel:Button;
      
      
      /**
       * Opens alliance channel, if available.
       */
      private var btnAllianceChannel:Button;
      
      
      /**
       * Opens first private channel which has unread messages.
       */
      private var btnPrivateChannel:Button;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var layout:HorizontalLayout = new HorizontalLayout();
         layout.gap = 0;
         this.layout = layout;
         
         btnMainChannel = new Button();
         btnMainChannel.addEventListener(MouseEvent.CLICK, btnMainChannel_clickHandler, false, 0, true);
         btnMainChannel.setStyle("skinClass", CChatOpenChanButtonMainSkin);
         btnMainChannel.toolTip = getString("tooltip.mainChannel");
         addElement(btnMainChannel);
         
         btnAllianceChannel = new Button();
         btnAllianceChannel.addEventListener(MouseEvent.CLICK, btnAllianceChannel_clickHandler, false, 0, true);
         btnAllianceChannel.setStyle("skinClass", CChatOpenChanButtonAllianceSkin);
         btnAllianceChannel.toolTip = getString("tooltip.allianceChannel");
         updateBtnAllianceChannel();
         addElement(btnAllianceChannel);
         
         btnPrivateChannel = new Button();
         btnPrivateChannel.addEventListener(MouseEvent.CLICK, btnPrivateChannel_clickHandler, false, 0, true);
         btnPrivateChannel.setStyle("skinClass", CChatOpenChanButtonPrivateSkin);
         btnPrivateChannel.toolTip = getString("tooltip.privateChannel");
         updateBtnPrivateChannel();
         addElement(btnPrivateChannel);
      }
      
      
      private function updateBtnAllianceChannel() : void
      {
         btnAllianceChannel.enabled = MCHAT.allianceChannelOpen;
      }
      
      
      private function updateBtnPrivateChannel() : void
      {
         btnPrivateChannel.enabled = MCHAT.privateChannelOpen;
      }
      
      
      /* ############################### */
      /* ### CHILDREN EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function btnMainChannel_clickHandler(event:MouseEvent) : void
      {
         NAV_CTRL.showChat();
         MCHAT.selectMainChannel();
      }
      
      
      private function btnAllianceChannel_clickHandler(event:MouseEvent) : void
      {
         NAV_CTRL.showChat();
         MCHAT.selectAllianceChannel();
      }
      
      
      private function btnPrivateChannel_clickHandler(event:MouseEvent) : void
      {
         NAV_CTRL.showChat();
         MCHAT.selectFirstPrivateChannel();
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_allianceChannelOpenChangeHandler(event:MChatEvent) : void
      {
         updateBtnAllianceChannel();
      }
      
      
      private function model_privateChannelOpenChangeHandler(event:MChatEvent) : void
      {
         updateBtnPrivateChannel();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getString(property:String) : String
      {
         return Localizer.string("Chat", property);
      }
   }
}