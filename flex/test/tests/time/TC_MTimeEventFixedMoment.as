package tests.time
{
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.definesMethod;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;

   import models.time.MTimeEvent;

   import models.time.MTimeEventFixedMoment;
   import models.time.events.MTimeEventEvent;
   
   import namespaces.change_flag;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.number.greaterThan;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   import testsutils.DateUtl;
   
   import utils.DateUtil;
   
   
   public class TC_MTimeEventFixedMoment
   {
      private var timeEvent:MTimeEventFixedMoment;

      [Before]
      public function setUp() : void {
         DateUtil.now = new Date().time;
         DateUtil.timeDiff = 0;
         timeEvent = new MTimeEventFixedMoment();
      }
      
      [Test]
      public function autoCreate() : void {
         var event:MTimeEventFixedMoment;
         var dateString:String = "2000-01-01T00:00:00+00:00";
         var date:Date = DateUtl.createUTC(2000, 0, 1);
         
         event = MTimeEventFixedMoment.autoCreate(null, dateString);
         assertThat( "creates new instance if [param currValue] is null", event, notNullValue() );
         assertThat( "parses date string passed in [param value]", event.occursAt, dateEqual (date) );
         
         event = MTimeEventFixedMoment.autoCreate(timeEvent, dateString);
         assertThat( "returns [param currValue] if it is not null", event, equals (timeEvent) );
         assertThat( "parses date string passed in [param value]", event.occursAt, dateEqual (date) );
      }
      
      [Test]
      public function defaultPropValues() : void {
         assertThat( "occursAt", timeEvent.occursAt, dateEqual (new Date(0)) );
         assertThat( "occursIn", timeEvent.occursIn, equals (0) );
         assertThat( "hasOccurred", timeEvent.hasOccurred, isTrue() );
         assertThat( "occurredBefore", timeEvent.occurredBefore, greaterThan(0) );
      }
      
      [Test]
      public function flagsSetWhenOccursAtIsChanged() : void {
         timeEvent.resetChangeFlags();
         timeEvent.occursAt = new Date();
         assertThat( "change_flag::occursAt", timeEvent.change_flag::occursAt, isTrue() );
         assertThat( "change_flag::occursIn", timeEvent.change_flag::occursIn, isTrue() );
         assertThat( "change_flag::hasOccurred", timeEvent.change_flag::hasOccurred, isTrue() );
         assertThat( "change_flag::overdue", timeEvent.change_flag::occurredBefore, isTrue() );
      }
      
      [Test]
      public function should_dispatch_change_events(): void {
         assertThat(
            "changing occursAt should dispatch OCCURS_IN_CHANGE, "
               + "OCCURS_AT_CHANGE, HAS_OCCURRED_CHANGE and "
               + "OCCURRED_BEFORE_CHANGE",
            function():void{ timeEvent.occursAt = new Date() },
            causes (timeEvent) .toDispatch (
               event (MTimeEventEvent.OCCURS_IN_CHANGE),
               event (MTimeEventEvent.OCCURS_AT_CHANGE),
               event (MTimeEventEvent.HAS_OCCURRED_CHANGE),
               event (MTimeEventEvent.OCCURRED_BEFORE_CHANGE)
            )
         );
         
         assertThat(
            "calling update() should dispatch OCCURS_IN_CHANGE",
            function():void{ timeEvent.update() },
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURS_IN_CHANGE)
         );
      }

      [Test]
      public function OCCURRED_BEFORE_CHANGE_event_dispatch_logic(): void {
         timeEvent.occursAt = new Date(2005, 0, 1);
         
         DateUtil.now = new Date(2000, 0, 1).time;
         assertThat(
            "should not dispatch OCCURRED_BEFORE_CHANGE if event has not yet occurred",
            timeEvent.update,
            not (causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURRED_BEFORE_CHANGE))
         );

         DateUtil.now = new Date(2005, 0, 1).time;
         assertThat(
            "should dispatch OCCURRED_BEFORE_CHANGE when current time reaches occursAt",
            timeEvent.update,
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURRED_BEFORE_CHANGE)
         );

         DateUtil.now = new Date(2005, 0, 2).time;
         assertThat(
            "should dispatch OCCURRED_BEFORE_CHANGE when occursAt is in the past and time advances further",
            timeEvent.update,
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.OCCURRED_BEFORE_CHANGE)
         );
      }
      
      
      [Test]
      public function HAS_OCCURRED_CHANGE_should_be_dispatched_when_current_time_passes_defined_moment(): void {
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         // 3rd of January, 2000
         timeEvent.occursAt = new Date(2000, 0, 3);
         
         assertThat(
            "should not dispatch HAS_OCCURRED_CHANGE if current time has not yet reached occursAt",
            function():void{ DateUtil.now = new Date(2000, 0, 2).time; timeEvent.update() },
            not (causes (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURRED_CHANGE))
         );
         
         assertThat(
            "should dispatch HAS_OCCURRED_CHANGE when current time reaches occursAt",
            function():void{ DateUtil.now = new Date(2000, 0, 3).time; timeEvent.update() },
            causes (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURRED_CHANGE)
         );
         
         assertThat(
            "should not dispatch HAS_OCCURRED_CHANGE if current time has has already passed occursAt",
            function():void{ DateUtil.now = new Date(2000, 0, 4).time; timeEvent.update() },
            not (causes (timeEvent) .toDispatchEvent (MTimeEventEvent.HAS_OCCURRED_CHANGE))
         );
      }

      [Test]
      public function occursAt_should_not_accept_null(): void {
         assertThat(
            function():void{ timeEvent.occursAt = null },
            throws (ArgumentError)
         );
      }

      [Test]
      public function occursIn_should_depend_on_occursAt_and_currentTime(): void {
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         
         // 1st of January, 1999
         timeEvent.occursAt = new Date(1999, 0, 1);
         assertThat(
            "should never be negative",
            timeEvent.occursIn, equals (0)
         );
         
         // 1st of January, 2000
         timeEvent.occursAt = new Date(2000, 0, 1);
         assertThat(
            "should be zero when occursAt is the same as current time",
            timeEvent.occursIn, equals (0)
         );
         
         // 3rd of January, 2000
         timeEvent.occursAt = new Date(2000, 0, 3);
         assertThat(
            "should change when occursAt changes",
            timeEvent.occursIn, equals (2 * 24 * 60 * 60)
         );
         
         // 2nd of January, 2000
         DateUtil.now = new Date(2000, 0, 2).time;
         assertThat(
            "should change when time advances",
            timeEvent.occursIn, equals (1 * 24 * 60 * 60)
         );
      }

      [Test]
      public function occurredBefore_depends_on_occursAt_and_currentTime(): void {
         timeEvent.occursAt = new Date(2000, 0, 5);
         
         DateUtil.now = new Date(2000, 0, 1).time;
         assertThat(
            "is 0 if event has not yet occurred",
            timeEvent.occurredBefore, equals (0)
         );

         DateUtil.now = new Date(2000, 0, 5).time;
         assertThat(
            "is 0 if event has just occurred",
            timeEvent.occurredBefore, equals (0)
         );

         DateUtil.now = new Date(2000, 0, 6).time;
         assertThat(
            "time in seconds that has passed since event has occurred",
            timeEvent.occurredBefore, equals (1 * 24 * 60 * 60)
         );
      }

      [Test]
      public function hasOccurred_should_be_true_when_event_has_passed_its_deadline(): void {
         // 2nd of January, 2000
         timeEvent.occursAt = new Date(2000, 0, 2);
         
         // 1st of January, 2000
         DateUtil.now = new Date(2000, 0, 1).time;
         assertThat(
            "should be false if time has not passed the deadline",
            timeEvent.hasOccurred, isFalse()
         );
         
         // 2nd of January, 2000
         DateUtil.now = new Date(2000, 0, 2).time;
         assertThat(
            "should be true if time has reached the deadline",
            timeEvent.hasOccurred, isTrue()
         );
         
         // 3rd of January, 2000
         DateUtil.now = new Date(2000, 0, 3).time;
         assertThat(
            "should be true if time has passed the deadline",
            timeEvent.hasOccurred, isTrue()
         );
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MTimeEventFixedMoment, definesProperties({
               "occursIn": withBindableTag (MTimeEventEvent.OCCURS_IN_CHANGE),
               "occursAt": withBindableTag (MTimeEventEvent.OCCURS_AT_CHANGE),
               "hasOccurred": withBindableTag (MTimeEventEvent.HAS_OCCURRED_CHANGE),
               "occurredBefore": withBindableTag (MTimeEventEvent.OCCURRED_BEFORE_CHANGE)
            })
         );
         assertThat(
            MTimeEventFixedMoment, definesMethod(
               "occurredBeforeString",
               withBindableTag (MTimeEventEvent.OCCURRED_BEFORE_CHANGE)
            )
         );
      }
   }
}