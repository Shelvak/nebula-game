/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/31/12
 * Time: 6:08 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification.parts {
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.technology.MChangedTechnology;

   import mx.collections.ArrayCollection;

   import utils.locale.Localizer;

   /*	  
    # EVENT_TECHNOLOGIES_CHANGED = 14
    #
    # params = {
    # :changed => [
    # [technology_name (String), old_scientists (Fixnum),
    # new_scientists (Fixnum)],
    # ["GroundDamage", 100, 80],
    # ...
    # ],
    # :paused => [technology_name (String), ..., ...]
    # }
   
    It should say:
   
    Dėl nepakankamo mokslininkų arba planetų kiekio buvo atlikti šie pakeitimai technologijoms:
   
    [list of renderers]*/
   public class TechnologiesChanged implements INotificationPart {
      public function TechnologiesChanged(notif:Notification = null) {
         super();
         if (notif)
         {
            var params: Object = notif.params;
            var _changed: Array = [];
            for each (var rawTech: Array in params.changed)
            {
               _changed.push(new MChangedTechnology(rawTech[0], rawTech[1],
                  rawTech[2]));
            }
            for each (var pausedTech: String in params.paused)
            {
               _changed.push(new MChangedTechnology(pausedTech));
            }
            changedList = new ArrayCollection(_changed);
         }
      }

      public var changedList: ArrayCollection;

      public function get title():String
      {
         return Localizer.string("Notifications", "title.technologiesChanged");
      }

      public function get message():String
      {
         return Localizer.string("Notifications", "message.technologiesChanged");
      }

      public function get insideMessage():String
      {
         return Localizer.string("Notifications", "insideMessage.technologiesChanged");
      }
      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}
