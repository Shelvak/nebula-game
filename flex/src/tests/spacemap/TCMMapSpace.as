package tests.spacemap
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import flash.errors.IllegalOperationError;
   
   import models.StaticSpaceObjectsAggregator;
   import models.Wreckage;
   import models.location.LocationMinimal;
   import models.map.MMapSpace;
   import models.map.events.MMapSpaceEvent;
   import models.map.events.MMapSpaceEventKind;
   import models.solarsystem.SolarSystem;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;

   public class TCMMapSpace
   {
      include "../asyncSequenceHelpers.as";
      
      
      private var map:MMapSpace;
      private var aggregator:StaticSpaceObjectsAggregator;
      private var wreckage:Wreckage;
      
      
      [Before]
      public function setUp() : void
      {
         runner = new SequenceRunner(this);
         map = new MMapSpace();
         wreckage = new Wreckage();
         wreckage.currentLocation = new LocationMinimal();
         aggregator = new StaticSpaceObjectsAggregator();
      };
      
      
      [Test]
      public function should_add_aggregator_if_another_one_does_not_occupy_the_same_space_sector() : void
      {
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         assertThat(map.objects, hasItem (aggregator) );
      };
      
      
      [Test]
      public function should_not_allow_adding_another_aggregator_in_the_already_occupied_sector() : void
      {
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         var anotherAggregator:StaticSpaceObjectsAggregator = new StaticSpaceObjectsAggregator();
         anotherAggregator.addItem(wreckage);
         assertThat(
            function():void{ map.addStaticObjectsAggregator(anotherAggregator) },
            throws (IllegalOperationError)
         );
      };
      
      
      [Test]
      public function should_remove_aggregator_if_it_is_present() : void
      {
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         map.removeStaticObjectsAggregator(aggregator);
         assertThat(map.objects, arrayWithSize (0));
      };
      
      
      [Test]
      public function should_create_new_aggregator_if_there_isnt_one_in_a_sector_and_add_given_object_to_it() : void
      {
         map.addStaticObject(wreckage);
         assertThat( map.objects, hasItem (hasProperty ("currentLocation", equals (wreckage.currentLocation))));
         assertThat( map.objects, hasItem (hasItem (wreckage)));
      };
      
      
      [Test]
      public function should_add_object_to_an_aggregator() : void
      {
         map.addStaticObject(wreckage);
         var ss:SolarSystem = new SolarSystem();
         map.addStaticObject(ss);
         assertThat( map.objects, hasItem( hasItems (wreckage, ss)));
      };
      
      
      [Test]
      public function should_remove_object_from_an_aggregator() : void
      {
         map.addStaticObject(wreckage);
         map.addStaticObject(new SolarSystem());
         map.removeStaticObject(wreckage);
         assertThat( map.objects, hasItem (not (hasItem (wreckage))));
      };
      
      
      [Test]
      public function should_remove_aggregator_when_the_last_object_is_removed_from_that_sector() : void
      {
         map.addStaticObject(wreckage);
         map.removeStaticObject(wreckage);
         assertThat( map.objects, arrayWithSize (0));
      };
      
      
      [Test(async, timeout=100)]
      public function should_dispatch_STATIC_OBJECTS_ADD_event_when_aggregator_has_been_added() : void
      {
         var ss:SolarSystem = new SolarSystem();
         ss.x = 1;
         ss.y = 1;
         aggregator.addItem(wreckage);
         
         addCall( function():void{ map.addStaticObjectsAggregator(aggregator) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_ADD,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event.objectsAggregator, equals (aggregator) );
            }
         );
         
         addCall( function():void{ map.addStaticObject(ss) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_ADD,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event.objectsAggregator.currentLocation, equals (ss.currentLocation) );
               assertThat( event.objectsAggregator, arrayWithSize (1) );
               assertThat( event.objectsAggregator, hasItem (ss) );
            }
         );
         
         runner.run();
      };
      
      
      [Test(async, timeout=100)]
      public function should_dispatch_STATIC_OBJECTS_REMOVE_event_when_aggregator_has_been_removed() : void
      {
         var ss:SolarSystem = new SolarSystem();
         ss.x = 1;
         ss.y = 1;
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         map.addStaticObject(ss);
         
         addCall( function():void{ map.removeStaticObjectsAggregator(aggregator) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_REMOVE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event.objectsAggregator, equals (aggregator) );
            }
         );
         
         addCall( function():void{ map.removeStaticObject(ss) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_REMOVE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event.objectsAggregator.currentLocation, equals (ss.currentLocation) );
               assertThat( event.objectsAggregator, arrayWithSize (1) );
               assertThat( event.objectsAggregator, hasItem (ss) );
            }
         );
         
         runner.run();
      };
      
      
      [Test(async, timeout=100)]
      public function should_dispatch_STATIC_OBJECTS_CHANGE_event_when_object_has_been_added_to_existing_aggregator() : void
      {
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         var ss:SolarSystem = new SolarSystem();
         
         // event should be dispatched when using MMapSpace.addStaticObject()
         addCall( function():void{ map.addStaticObject(ss) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event, hasProperties({
                  "kind": MMapSpaceEventKind.OBJECT_ADD,
                  "objectsAggregator": aggregator,
                  "object": ss
               }));
            }
         );
         
         // event should be dispatched when aggregator has been modified directly
         addCall( function():void{
            map.removeStaticObject(ss);
            aggregator.addItem(ss);
         });
         addWaitFor( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE );
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event, hasProperties({
                  "kind": MMapSpaceEventKind.OBJECT_ADD,
                  "objectsAggregator": aggregator,
                  "object": ss
               }));
            }
         );
         
         runner.run();
      };
      
      
      [Test(async, timeout=100)]
      public function should_dispatch_STATIC_OBJECTS_CHANGE_event_when_object_has_been_removed_from_existing_aggregator() : void
      {
         var ss:SolarSystem = new SolarSystem();
         aggregator.addItem(ss);
         aggregator.addItem(wreckage);
         map.addStaticObjectsAggregator(aggregator);
         
         // event must be dispached when using MMapSpace.removeStaticObject()
         addCall( function():void{ map.removeStaticObject(ss) });
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event, hasProperties({
                  "kind": MMapSpaceEventKind.OBJECT_REMOVE,
                  "objectsAggregator": aggregator,
                  "object": ss
               }));
            }
         );
         
         // event should be dispatched when we directly modify an aggregator
         addCall( function():void{
            map.addStaticObject(ss);
            aggregator.removeItemAt(aggregator.getItemIndex(ss));
         });
         addWaitFor( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE );
         addWaitForEvent( map, MMapSpaceEvent.STATIC_OBJECTS_CHANGE,
            function(event:MMapSpaceEvent) : void
            {
               assertThat( event, hasProperties({
                  "kind": MMapSpaceEventKind.OBJECT_REMOVE,
                  "objectsAggregator": aggregator,
                  "object": ss
               }));
            }
         );
         
         runner.run();
      }
   }
}