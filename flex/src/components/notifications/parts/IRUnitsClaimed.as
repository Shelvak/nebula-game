/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/1/12
 * Time: 10:48 AM
 * To change this template use File | Settings | File Templates.
 */
package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.UnitsClaimedSkin;

   import models.notification.parts.UnitsClaimed;

   import spark.components.DataGroup;
   import spark.components.Label;


   public class IRUnitsClaimed extends IRNotificationPartBase
   {
      public function IRUnitsClaimed()
      {
         super();
         setStyle("skinClass", UnitsClaimedSkin);
      };


      [SkinPart(required="true")]
      public var location:MiniLocationComp;


      [SkinPart(required="true")]
      public var units:DataGroup;


      [SkinPart(required="true")]
      public var message:Label;


      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part:UnitsClaimed = UnitsClaimed(notificationPart);
            units.dataProvider = part.units;
            location.location = part.location;
            message.text = part.message;
         }
         f_NotificationPartChange = false;
      }
   }
}