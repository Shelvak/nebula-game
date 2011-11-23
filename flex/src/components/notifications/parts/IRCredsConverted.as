package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.CredsConvertedSkin;

   import models.notification.parts.CredsConverted;

   import spark.components.Label;

   import utils.locale.Localizer;


   public class IRCredsConverted extends IRNotificationPartBase
   {
      public function IRCredsConverted() {
         super();
         setStyle("skinClass", CredsConvertedSkin);
      }

      [SkinPart(required="true")]
      public var lblContent:Label;
      [SkinPart(required="true")]
      public var lblPersonalCreds:Label;
      [SkinPart(required="true")]
      public var lblAllianceCreds:Label;
      [SkinPart(required="true")]
      public var lblPersonalCredsTotal:Label;

      private function get model(): CredsConverted
      {
         return CredsConverted(notificationPart);
      }

      private function getLabel(property:String, parameters:Array = null) : String {
         return Localizer.string("Notifications", 'credsConverted.' + property,
            parameters);
      }
      
      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange)
            lblContent.text = model.content;
            if (model.personalCreds > 0)
            {
               lblPersonalCreds.text =  getLabel('personalCreds',
                       [model.personalCreds]);
               lblPersonalCreds.visible = true;
            }
            else
            {
               lblPersonalCreds.visible = false;
            }
            if (model.allianceCredsPerPlayer > 0)
            {
               lblAllianceCreds.text = getLabel('allianceCreds',
                       [model.allianceCredsPerPlayer, model.totalAllianceCreds]);
               lblAllianceCreds.visible = true;
            }
            else
            {
               lblAllianceCreds.visible = false;
            }
            if (model.personalCreds > 0 && model.allianceCredsPerPlayer > 0)
            {
               lblPersonalCredsTotal.text = getLabel('personalCredsTotal',
                       [model.allianceCredsPerPlayer + model.personalCreds]);
               lblPersonalCredsTotal.visible = true;
            }
            else
            {
               lblPersonalCredsTotal.visible = false;
            }
         f_NotificationPartChange = false;
      }
   }
}