package tests.time
{
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;
   
   import models.time.MTimeEventFixedInterval;
   import models.time.events.MTimeEventEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.notNullValue;
   
   import utils.DateUtil;
   
   
   public class TC_MTimeEventFixedInterval
   {
      public function TC_MTimeEventFixedInterval()
      {
      }
      
      
      private var timeEvent:MTimeEventFixedInterval;
      
      
      [Before]
      public function setUp() : void
      {
         timeEvent = new MTimeEventFixedInterval();
      };
      
      
      [After]
      public function tearDown() : void
      {
         timeEvent = null;
      };
      
      [Test]
      public function defaultPropValues() : void {
         assertThat( "occuresIn", timeEvent.occuresIn, equals (0) );
         assertThat( "occuresAt", timeEvent.occuresAt, notNullValue() );
      }
      
      
      [Test]
      public function should_dispatch_change_events() : void
      {
         assertThat(
            "changing occuresIn should dispatch OCCURES_IN_CHANGE, OCCURES_AT_CHANGE and HAS_OCCURED_CHANGE",
            function():void{ timeEvent.occuresIn = 10 },
            causes (timeEvent) .toDispatch (
               event (MTimeEventEvent.OCCURES_IN_CHANGE),
               event (MTimeEventEvent.OCCURES_AT_CHANGE),
               event (MTimeEventEvent.HAS_OCCURED_CHANGE)
            )
         );
         
         assertThat(
            "calling update() should dispatch OCCURES_AT_CHANGE",
            function():void{ timeEvent.update() },
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURES_AT_CHANGE)
         );
      };
      
      
      [Test]
      public function occuresIn_should_override_negative_values_with_zero() : void
      {
         timeEvent.occuresIn = -5;
         assertThat( timeEvent.occuresIn, equals (0) );
      };
      
      
      [Test]
      public function occuresAt_should_depend_on_occuresIn_and_current_time() : void
      {
         // one minute
         DateUtil.now = 60000;
         
         
         timeEvent.occuresIn = 0;
         assertThat(
            "should never be null",
            timeEvent.occuresAt, notNullValue()
         );
         assertThat(
            "should be equal to current time",
            timeEvent.occuresAt, dateEqual (new Date(DateUtil.now))
         );
         
         
         timeEvent.occuresIn = 10;
         assertThat(
            "should change when occuresIn changes",
            timeEvent.occuresAt, dateEqual (new Date(DateUtil.now + timeEvent.occuresIn * 1000))
         );
         
         
         // +5 seconds
         DateUtil.now += 5000;
         assertThat(
            "occuresAt should change when time advances",
            timeEvent.occuresAt, dateEqual (new Date(DateUtil.now + timeEvent.occuresIn * 1000))
         );
      };
      
      
      [Test]
      public function hasOccured_should_allways_be_false() : void
      {
         timeEvent.occuresIn = 0;
         assertThat(
            "should be false if occuresIn is 0",
            timeEvent.hasOccured, isFalse()
         );
         
         timeEvent.occuresIn = 10;
         assertThat(
            "should be false if occuresIn is positive",
            timeEvent.hasOccured, isFalse()
         );
      };
   }
}