package tests.spacemap
{
   import com.adobe.errors.IllegalStateError;
   
   import ext.hamcrest.object.equals;
   
   import flash.errors.IllegalOperationError;
   
   import models.MStaticSpaceObjectsAggregator;
   import models.MWreckage;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   
   
   public class TCStaticSpaceObjectsAggregator
   {
      [Test]
      public function reading_currentLocation_should_cause_state_error_if_there_are_no_static_objects() : void
      {
         assertThat(
            function():void{ new MStaticSpaceObjectsAggregator().currentLocation },
            throws (IllegalOperationError)
         );
      };
      
      
      [Test]
      public function should_not_allow_aggregation_of_objects_not_in_the_same_location() : void
      {
         var loc:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
         loc.location = new LocationMinimal();
         loc.angle = 180;
         loc.position = 1;
         var wreckage:MWreckage = new MWreckage();
         wreckage.currentLocation = loc.location;
         var planet:MSSObject = new MSSObject();
         planet.angle = 0;
         planet.position = 0;
         var objects:MStaticSpaceObjectsAggregator = new MStaticSpaceObjectsAggregator();
         
         objects.addItem(planet);
         assertThat(
            function():void{ objects.addItem(wreckage) },
            throws (IllegalOperationError)
         );
      };
      
      
      [Test]
      public function should_not_allow_adding_two_or_more_static_objects_of_the_same_type() : void
      {
         var wreckage:MWreckage = new MWreckage();
         wreckage.currentLocation = new LocationMinimal();
         var solarSystem:SolarSystem = new SolarSystem();
         var objects:MStaticSpaceObjectsAggregator = new MStaticSpaceObjectsAggregator();
         objects.addItem(wreckage);
         objects.addItem(solarSystem);
         
         assertThat(
            function():void{ objects.addItem(new SolarSystem()) },
            throws (IllegalOperationError)
         );
      };
      
      
      [Test]
      public function should_return_same_location_as_the_first_object_in_the_list() : void
      {
         var wreckage:MWreckage = new MWreckage();
         wreckage.currentLocation = new LocationMinimal();
         var objects:MStaticSpaceObjectsAggregator = new MStaticSpaceObjectsAggregator();
         objects.addItem(wreckage);
         assertThat( objects.currentLocation, equals (wreckage.currentLocation) );
      };
      
      
      [Test]
      public function should_not_be_navigable_if_there_is_no_navigable_object() : void
      {
         var wreckage:MWreckage = new MWreckage();
         wreckage.currentLocation = new LocationMinimal();
         var objects:MStaticSpaceObjectsAggregator = new MStaticSpaceObjectsAggregator();
         objects.addItem(wreckage);
         assertThat( objects.isNavigable, equals (false) );
      };
      
      
      [Test]
      public function should_be_navigable_if_there_is_a_navigable_object() : void
      {
         var objects:MStaticSpaceObjectsAggregator = new MStaticSpaceObjectsAggregator();
         objects.addItem(new MSSObject());
         assertThat( objects.isNavigable, equals (true) );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
   }
}