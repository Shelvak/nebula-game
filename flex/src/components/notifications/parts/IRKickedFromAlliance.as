package components.notifications.parts
{
   import components.alliance.AllianceScreenM;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.KickedFromAllianceSkin;
   
   import flash.events.MouseEvent;
   
   import models.notification.parts.KickedFromAlliance;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRKickedFromAlliance extends IRNotificationPartBase
   {
      public function IRKickedFromAlliance()
      {
         super();
         setStyle("skinClass", KickedFromAllianceSkin);
      };
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      public var lblAbout: Label;
      
      [SkinPart(required="true")]
      public var btnAlly: Button;
      
      private function setLblAbout() : void
      {
         if (lblAbout)
         {
            lblAbout.text = Localizer.string(
               'Notifications', 'label.kickedFromAlliance');
         }
      };
      
      private function setBtnAlly() : void
      {
         if (btnAlly) 
         {
            btnAlly.label = kickedFromAlliance.alliance.name;
            btnAlly.addEventListener(MouseEvent.CLICK, 
               function (e: MouseEvent): void
               {
                  AllianceScreenM.getInstance().showScreen(kickedFromAlliance.alliance.id);
               });
         }
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get kickedFromAlliance() : KickedFromAlliance
      {
         return notificationPart as KickedFromAlliance;
      }
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            setLblAbout();
            setBtnAlly();
         }
         f_NotificationPartChange = false;
      }
   }
}