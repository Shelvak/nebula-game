/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 8/1/12
 * Time: 10:38 AM
 * To change this template use File | Settings | File Templates.
 */
package models.notification.parts
{
   import controllers.objects.ObjectClass;

   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.unit.UnitBuildingEntry;

   import mx.collections.ArrayCollection;

   import utils.ModelUtil;
   import utils.Objects;
   import utils.locale.Localizer;


   public class UnitsClaimed extends BaseModel implements INotificationPart
   {
      public function UnitsClaimed(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            location = Objects.create(Location, params.planet);
            units = new ArrayCollection();
            for (var type:String in params.unitCounts)
            {
               units.addItem(
                  new UnitBuildingEntry(
                     ModelUtil.getModelType(ObjectClass.UNIT, type),
                     params.unitCounts[type]
                  )
               );
            }
         }
      }


      public function get title() : String
      {
         return Localizer.string("Notifications", "title.unitsClaimed");
      }


      public function get message() : String
      {
         if (location == null)
         {
            return null;
         }
         return Localizer.string("Notifications", "message.unitsClaimed",
            [location.player.name]);
      }


      public var location:Location;
      public var units:ArrayCollection;

      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
   }
}