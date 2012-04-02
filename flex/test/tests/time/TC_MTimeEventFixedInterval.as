package tests.time
{
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.definesProperty;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;

   import models.time.MTimeEventFixedInterval;
   import models.time.events.MTimeEventEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.notNullValue;
   
   import utils.DateUtil;
   
   
   public class TC_MTimeEventFixedInterval
   {
      private var timeEvent: MTimeEventFixedInterval;
      
      
      [Before]
      public function setUp(): void {
         timeEvent = new MTimeEventFixedInterval();
      }

      [After]
      public function tearDown(): void {
         timeEvent = null;
      }
      
      [Test]
      public function defaultPropValues(): void {
         assertThat( "occursIn", timeEvent.occursIn, equals (0) );
         assertThat( "occursAt", timeEvent.occursAt, notNullValue() );
      }
      
      [Test]
      public function should_dispatch_change_events(): void {
         assertThat(
            "changing occursIn should dispatch OCCURS_IN_CHANGE, "
               + "OCCURS_AT_CHANGE and HAS_OCCURRED_CHANGE",
            function():void{ timeEvent.occursIn = 10 },
            causes (timeEvent) .toDispatch (
               event (MTimeEventEvent.OCCURS_IN_CHANGE),
               event (MTimeEventEvent.OCCURS_AT_CHANGE),
               event (MTimeEventEvent.HAS_OCCURRED_CHANGE)
            )
         );
         
         assertThat(
            "calling update() should dispatch OCCURS_AT_CHANGE",
            function():void{ timeEvent.update() },
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURS_AT_CHANGE)
         );
      }

      [Test]
      public function occursIn_should_override_negative_values_with_zero() : void {
         timeEvent.occursIn = -5;
         assertThat( timeEvent.occursIn, equals (0) );
      }

      [Test]
      public function occursAt_should_depend_on_occursIn_and_current_time() : void
      {
         // one minute
         DateUtil.now = 60000;

         timeEvent.occursIn = 0;
         assertThat(
            "should never be null",
            timeEvent.occursAt, notNullValue()
         );
         assertThat(
            "should be equal to current time",
            timeEvent.occursAt, dateEqual (new Date(DateUtil.now))
         );

         timeEvent.occursIn = 10;
         assertThat(
            "should change when occursIn changes",
            timeEvent.occursAt, dateEqual (new Date(DateUtil.now + timeEvent.occursIn * 1000))
         );

         // +5 seconds
         DateUtil.now += 5000;
         assertThat(
            "occursAt should change when time advances",
            timeEvent.occursAt, dateEqual (new Date(DateUtil.now + timeEvent.occursIn * 1000))
         );
      }

      [Test]
      public function hasOccurred_should_always_be_false() : void {
         timeEvent.occursIn = 0;
         assertThat(
            "should be false if occursIn is 0",
            timeEvent.hasOccurred, isFalse()
         );
         
         timeEvent.occursIn = 10;
         assertThat(
            "should be false if occursIn is positive",
            timeEvent.hasOccurred, isFalse()
         );
      }

      [Test]
      public function propertiesMetadata(): void {
         assertThat(
            MTimeEventFixedInterval, definesProperty(
               "occursIn",
               withBindableTag (MTimeEventEvent.OCCURS_IN_CHANGE)
            )
         );
      }
   }
}