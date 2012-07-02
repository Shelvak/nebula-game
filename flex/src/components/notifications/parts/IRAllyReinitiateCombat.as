/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 7/2/12
 * Time: 4:43 PM
 * To change this template use File | Settings | File Templates.
 */
package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllyReinitiateCombatSkin;

   import models.notification.parts.AllyReinitiateCombat;
   import spark.components.Label;

   public class IRAllyReinitiateCombat extends IRNotificationPartBase
   {
      public function IRAllyReinitiateCombat() {
         super();
         setStyle("skinClass", AllyReinitiateCombatSkin);
      }

      [SkinPart(required="true")]
      public var lblContent:Label;

      [SkinPart(required="true")]
      public var location:MiniLocationComp;

      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange)
            var part:AllyReinitiateCombat = AllyReinitiateCombat(notificationPart);
            lblContent.text = part.content;
            location.location = part.location;
         f_NotificationPartChange = false;
      }
   }
}