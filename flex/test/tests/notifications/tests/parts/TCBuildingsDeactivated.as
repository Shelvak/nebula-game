package tests.notifications.tests.parts
{
   import models.notification.Notification;
   import models.notification.parts.BuildingsDeactivated;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   
   import tests.notifications.Data;

   
   public class TCBuildingsDeactivated
   {
      private var part:BuildingsDeactivated = null;
      
      
      [Test(description="tests if constructor sets properties")]
      public function testConstructor() : void
      {
         var notif:Notification = new Notification();
         notif.params = Data.partBuildingsDeactivated;
         part = new BuildingsDeactivated(notif);
         
         assertThat( part.location, notNullValue() );
         assertThat( part.location, hasProperties({
            "id": 4,
            "name": "G12-SS18-P4",
            "solarSystemId": 18
         }));
         
         assertThat( part.buildings, hasItems (
            hasProperties ({"type": "Building::Mothership", "count": 1}),
            hasProperties ({"type": "Building::Barracks", "count": 2})
         ));
      }
   }
}