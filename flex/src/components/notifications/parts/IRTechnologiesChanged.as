/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/31/12
 * Time: 6:42 PM
 * To change this template use File | Settings | File Templates.
 */
package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.TechnologiesChangedSkin;

   import models.notification.parts.TechnologiesChanged;

   import spark.components.DataGroup;
   import spark.components.Label;


   public class IRTechnologiesChanged extends IRNotificationPartBase
   {
      public function IRTechnologiesChanged()
      {
         super();
         setStyle("skinClass", TechnologiesChangedSkin);
      };


      [SkinPart(required="true")]
      public var technologies:DataGroup;


      [SkinPart(required="true")]
      public var insideMessage:Label;


      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part:TechnologiesChanged = TechnologiesChanged(notificationPart);
            technologies.dataProvider = part.changedList;
            insideMessage.text = part.insideMessage;
         }
         f_NotificationPartChange = false;
      }
   }
}
