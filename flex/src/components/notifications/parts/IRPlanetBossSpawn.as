/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 7/2/12
 * Time: 3:06 PM
 * To change this template use File | Settings | File Templates.
 */
package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.PlanetBossSpawnSkin;

   import models.notification.parts.PlanetBossSpawn;

   import spark.components.Label;

   public class IRPlanetBossSpawn extends IRNotificationPartBase
   {
      public function IRPlanetBossSpawn() {
         super();
         setStyle("skinClass", PlanetBossSpawnSkin);
      }

      [SkinPart(required="true")]
      public var lblContent:Label;

      [SkinPart(required="true")]
      public var location:MiniLocationComp;

      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part:PlanetBossSpawn = PlanetBossSpawn(notificationPart);
            lblContent.text = part.content;
            location.location = part.location;
         }
         f_NotificationPartChange = false;
      }
   }
}