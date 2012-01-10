package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllianceOwnerChangedSkin;

   import models.notification.parts.AllianceOwnerChanged;

   import spark.components.RichEditableText;

   import spark.components.RichEditableText;
   import spark.components.RichText;


   public class IRAllianceOwnerChanged extends IRNotificationPartBase
   {
      public function IRAllianceOwnerChanged() {
         super();
         setStyle("skinClass", AllianceOwnerChangedSkin);
      }

      [SkinPart(required="true")]
      public var txtContent:RichEditableText;

      protected override function partAdded(partName:String,
                                            instance:Object): void {
         super.partAdded(partName, instance);
         if (instance == txtContent) {
            txtContent.editable = false;
            txtContent.selectable = false;
         }
      }

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_NotificationPartChange) {
            txtContent.textFlow =
               AllianceOwnerChanged(notificationPart).getContent();
         }
         f_NotificationPartChange = false;
      }
   }
}
