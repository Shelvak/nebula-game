/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/24/12
 * Time: 1:29 PM
 * To change this template use File | Settings | File Templates.
 */
package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.PlayerAttachedSkin;


   public class IRPlayerAttached extends IRNotificationPartBase
   {
      public function IRPlayerAttached()
      {
         super();
         setStyle("skinClass", PlayerAttachedSkin);
      };

      protected override function commitProperties() : void
      {
         super.commitProperties();
         f_NotificationPartChange = false;
      }
   }
}