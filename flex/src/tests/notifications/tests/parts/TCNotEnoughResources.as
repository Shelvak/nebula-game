package tests.notifications.tests.parts
{
   import models.notification.parts.NotEnoughResources;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   
   import tests.notifications.Data;

   
   public class TCNotEnoughResources
   {
      private var part:NotEnoughResources = null;
      
      
      [Test(description="Test if constructor sets properties")]
      public function testConstructor() : void
      {
         part = new NotEnoughResources(Data.partNotEnoughResources);
         
         assertThat( part.constructables, notNullValue() );
         assertThat( part.constructables, hasItems(
            hasProperties ({"type": "Mothership", "count": 1}),
            hasProperties ({"type": "Trooper", "count": 5})
         ));
         
         assertThat( part.location, notNullValue() );
         assertThat( part.location, hasProperties ({
            "id": 2,
            "name": "G12-SS16-P2",
            "solarSystemId": 16
         }));
      }
   }
}