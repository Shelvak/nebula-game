package tests.time
{
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causesTarget;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;
   
   import models.time.MTimeEventFixedMoment;
   import models.time.events.MTimeEventEvent;
   
   import namespaces.change_flag;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   import testsutils.DateUtl;
   
   import utils.DateUtil;
   
   
   public class TC_MTimeEventFixedMoment
   {
      public function TC_MTimeEventFixedMoment() {
      }
      
      
      private var timeEvent:MTimeEventFixedMoment;
      
      
      [Before]
      public function setUp() : void {
         DateUtil.now = new Date().time;
         timeEvent = new MTimeEventFixedMoment();
      }
      
      [Test]
      public function autoCreate() : void {
         var event:MTimeEventFixedMoment;
         var dateString:String = "2000-01-01T00:00:00+00:00";
         var date:Date = DateUtl.createUTC(2000, 0, 1);
         
         event = MTimeEventFixedMoment.autoCreate(null, dateString);
         assertThat( "creates new instance if [param currValue] is null", event, notNullValue() );
         assertThat( "parses date string passed in [param value]", event.occuresAt, dateEqual (date) );
         
         event = MTimeEventFixedMoment.autoCreate(timeEvent, dateString);
         assertThat( "returns [param currValue] if it is not null", event, equals (timeEvent) );
         assertThat( "parses date string passed in [param value]", event.occuresAt, dateEqual (date) );
      }
      
      [Test]
      public function defaultPropValues() : void {
         assertThat( "occuresAt", timeEvent.occuresAt, dateEqual (new Date(0)) );
         assertThat( "occuresIn", timeEvent.occuresIn, equals (0) );
         assertThat( "hasOccured", timeEvent.hasOccured, isTrue() );
      }
      
      [Test]
      public function flagsSetWhenOccuresAtIsChanged() : void {
         timeEvent.resetChangeFlags();
         timeEvent.occuresAt = new Date();
         assertThat( "change_flag::occuresAt", timeEvent.change_flag::occuresAt, isTrue() );
         assertThat( "change_flag::occuresIn", timeEvent.change_flag::occuresIn, isTrue() );
         assertThat( "change_flag::hasOccured", timeEvent.change_flag::hasOccured, isTrue() );
      }
      
      [Test]
      public function should_dispatch_change_events() : void
      {
         assertThat(
            "changing occuresAt should dispatch OCCURES_IN_CHANGE, OCCURES_AT_CHANGE and HAS_OCCURED_CHANGE",
            function():void{ timeEvent.occuresAt = new Date() },
            causesTarget (timeEvent) .toDispatch (
               event (MTimeEventEvent.OCCURES_IN_CHANGE),
               event (MTimeEventEvent.OCCURES_AT_CHANGE),
               event (MTimeEventEvent.HAS_OCCURED_CHANGE)
            )
         );
         
         assertThat(
            "calling update() should dispatch OCCURES_IN_CHANGE",
            function():void{ timeEvent.update() },
            causesTarget (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURES_IN_CHANGE)
         );
      };
      
      
      [Test]
      public function HAS_OCCURED_CHANGE_should_be_dispatched_when_current_time_passes_defined_moment() : void
      {
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         // 3rd of January, 2000
         timeEvent.occuresAt = new Date(2000, 0, 3);
         
         assertThat(
            "should not dispatch HAS_OCCURED_CHANGE if current time has not yet reached occuresAt",
            function():void{ DateUtil.now = new Date(2000, 0, 2).time; timeEvent.update() },
            not (causesTarget (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURED_CHANGE))
         );
         
         assertThat(
            "should dispatch HAS_OCCURED_CHANGE when current time reaches occuresAt",
            function():void{ DateUtil.now = new Date(2000, 0, 3).time; timeEvent.update() },
            causesTarget (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURED_CHANGE)
         );
         
         assertThat(
            "should not dispatch HAS_OCCURED_CHANGE if current time has has already passed occuresAt",
            function():void{ DateUtil.now = new Date(2000, 0, 4).time; timeEvent.update() },
            not (causesTarget (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURED_CHANGE))
         );
      };
      
      
      [Test]
      public function occuresAt_should_not_accept_null() : void
      {
         assertThat(
            function():void{ timeEvent.occuresAt = null },
            throws (ArgumentError)
         );
      };
      
      
      [Test]
      public function occuresIn_should_depend_on_occuresAt_and_currentTime() : void
      {
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         
         // 1st of January, 1999
         timeEvent.occuresAt = new Date(1999, 0, 1);
         assertThat(
            "should never be negative",
            timeEvent.occuresIn, equals (0)
         );
         
         // 1st of January, 2000
         timeEvent.occuresAt = new Date(2000, 0, 1);
         assertThat(
            "should be zero when occuresAt is the same as current time",
            timeEvent.occuresIn, equals (0)
         );
         
         // 3rd of January, 2000
         timeEvent.occuresAt = new Date(2000, 0, 3);
         assertThat(
            "should change when occuresAt changes",
            timeEvent.occuresIn, equals (2 * 24 * 60 * 60)
         );
         
         // 2nd of January, 2000
         DateUtil.now = new Date(2000, 0, 2).time;
         assertThat(
            "should change when time advances",
            timeEvent.occuresIn, equals (1 * 24 * 60 * 60)
         );
      };
      
      
      [Test]
      public function hasOccured_should_be_true_when_event_has_passed_its_deadline() : void
      {
         // 2nd of January, 2000
         timeEvent.occuresAt = new Date(2000, 0, 2);
         
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         assertThat(
            "should be false if time has not passed the deadline",
            timeEvent.hasOccured, isFalse()
         );
         
         // 2nd of January, 2000
         DateUtil.now = new Date(2000, 0, 2).time;
         assertThat(
            "should be true if time has reached the deadline",
            timeEvent.hasOccured, isTrue()
         );
         
         // 3rd of January, 2000
         DateUtil.now = new Date(2000, 0, 3).time;
         assertThat(
            "should be true if time has passed the deadline",
            timeEvent.hasOccured, isTrue()
         );
      };
   }
}