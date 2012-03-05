package tests.movement
{
   import components.movement.speedup.BaseTripValues;
   import components.movement.speedup.SpeedupValues;
   import components.movement.speedup.TimeBasedSpeedControl;
   import components.movement.speedup.events.SpeedControlEvent;

   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;

   import namespaces.change_flag;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;

   import utils.DateUtil;


   public class TC_TimeBasedSpeedControl
   {
      private var baseValues: BaseTripValues;
      private var speedupValues: SpeedupValues;
      private var control: TimeBasedSpeedControl;

      private function get now(): Number {
         return DateUtil.now;
      }

      [Before]
      public function setUp(): void {
         DateUtil.now = new Date(2010, 0, 1).time;
         MovementTestUtil.setUp();
         setUpInitialValues(10);
      }

      private function setUpInitialValues(tripTime: int): void {
         baseValues = new BaseTripValues(tripTime, 10);
         speedupValues = new SpeedupValues(baseValues);
         control = new TimeBasedSpeedControl(baseValues, speedupValues);
      }

      [After]
      public function tearDown(): void {
         DateUtil.now = 0;
         MovementTestUtil.tearDown();
      }

      [Test]
      public function initialValues(): void {
         assertThat(
            "speed should not be altered",
            control.speedModifier, equals (1)
         );
         assertThat(
            "arrival date should be 10 seconds from now",
            control.arrivalEvent.occuresAt,
            dateEqual (new Date(2010, 0, 1, 0, 0, 10))
         );
      }

      [Test]
      public function reset(): void {
         control.arrivalSeconds = 15;
         control.reset();
         assertThat(
            "speed modifier should have default value",
            control.speedModifier, equals (1)
         );
         assertThat(
            "arrival date should be 10 seconds from now",
            control.arrivalEvent.occuresAt,
            dateEqual (new Date(2010, 0, 1, 0, 0, 10))
         );
      }


      [Test]
      public function timePartsGetters(): void {
         speedupValues.speedModifier = 0.5;
         assertThat( "year", control.arrivalYear, equals (2010) );
         assertThat( "month", control.arrivalMonth, equals (1) );
         assertThat( "day", control.arrivalDay, equals (1) );
         assertThat( "hour", control.arrivalHours, equals (0) );
         assertThat( "minute", control.arrivalMinutes, equals (0) );
         assertThat( "second", control.arrivalSeconds, equals (5) );
      }

      [Test]
      public function setTimeInRange(): void {
         MovementTestUtil.setUp(0.1, 4000000);

         function assertArrivalDate(date: Date, message: String): void {
            assertThat(
               "arrival date should be " + message + " from now",
               control.arrivalEvent.occuresAt, dateEqual (date)
            );
         }
         function assertSpeedModifier(value: Number): void {
            assertThat( "speedModifier", control.speedModifier, equals (value) );
         }

         control.arrivalSeconds = 20;
         assertArrivalDate(
            new Date(2010, 0, 1, 0, 0, 20), "20 seconds"
         );
         assertSpeedModifier(2);
         control.arrivalSeconds = 10;

         control.arrivalMinutes = 1;
         assertArrivalDate(
            new Date(2010, 0, 1, 0, 1, 10), "1 minute and 10 seconds"
         );
         assertSpeedModifier(7);
         control.arrivalMinutes = 0;

         control.arrivalHours = 1;
         assertArrivalDate(
            new Date(2010, 0, 1, 1, 0, 10), "1 hour and 10 seconds"
         );
         assertSpeedModifier(361);
         control.arrivalHours = 0;

         control.arrivalDay = 2;
         assertArrivalDate(
            new Date(2010, 0, 2, 0, 0, 10), "1 day and 10 seconds"
         );
         assertSpeedModifier(8641);
         control.arrivalDay = 1;

         control.arrivalMonth = 2;
         assertArrivalDate(
            new Date(2010, 1, 1, 0, 0, 10), "1 month and 10 seconds"
         );
         assertSpeedModifier(267841);
         control.arrivalMonth = 1;

         control.arrivalYear = 2011;
         assertArrivalDate(
            new Date(2011, 0, 1, 0, 0, 10), "1 year and 10 seconds"
         );
         assertSpeedModifier(3153601);
      }

      [Test]
      public function setArrivalDateToThePast(): void {
         // max speedup - 10000x
         MovementTestUtil.setUp(0.0001);
         control.arrivalYear = 2009;
         assertThat(
            "should be impossible to set arrival time to the past",
            control.arrivalEvent.occuresAt,
            dateEqual (new Date(2010, 0, 1, 0, 0, 1))
         );
      }

      [Test]
      public function arrivalDateBoundBySpeedModifierLimits(): void {
         MovementTestUtil.setUp(0.5, 2.0);

         control.arrivalSeconds = 4;
         assertThat(
            "speed modifier should not be lower then minimum",
            control.speedModifier, equals (0.5)
         );
         assertThat(
            "arrival date should be 5 seconds from now",
            control.arrivalEvent.occuresAt,
            dateEqual (new Date(2010, 0, 1, 0, 0, 5))
         );

         control.arrivalSeconds = 21;
         assertThat(
            "speed modifier should not exceed maximum",
            control.speedModifier, equals (2.0)
         );
         assertThat(
            "arrival date should be 20 seconds from now",
            control.arrivalEvent.occuresAt,
            dateEqual(new Date(2010, 0, 1, 0, 0, 20))
         );
      }

      [Test]
      public function resetChangeFlags(): void {
         control.resetChangeFlags();
         assertThat(
            "resetChangeFlags() should call arrivalEvent.resetChangeFlags()",
            control.arrivalEvent.change_flag::occuresAt, isFalse()
         );
      }

      [Test]
      public function significantTimeAdvancement(): void {
         function assertArrivalDateIsTheSame(): void {
            assertThat(
               "arrival date should stay the same",
               control.arrivalEvent.occuresAt,
               dateEqual (new Date(2010, 0, 1, 0, 0, 10), 100)
            );
         }

         advanceTimeBy(1);
         assertThat(
            "speed modifier should shift to minimum",
            control.speedModifier, equals (0.9)
         );
         assertArrivalDateIsTheSame();

         advanceTimeBy(8);
         assertThat(
            "speed modifier should have reached minimum",
            control.speedModifier, equals (0.1)
         );
         assertArrivalDateIsTheSame();

         advanceTimeBy(1);
         assertThat(
            "speed modifier should stay at minimum when it reached it",
            control.speedModifier, equals (0.1)
         );
         assertThat(
            "arrival date should be shifted to compensate time advancement "
               + "when speed modifier is at minimum",
            control.arrivalEvent.occuresAt,
            dateEqual (new Date(2010, 0, 1, 0, 0, 11), 100)
         );
      }

      [Test]
      public function timeAdvancementWithinTheSameSecond(): void {
         function assertNotChanged(): void {
            assertThat(
               "speed modifier should not have changed",
               control.speedModifier, equals (1)
            );
            assertThat(
               "arrival date should not have changed",
               control.arrivalEvent.occuresAt,
               dateEqual (new Date(2010, 0, 1, 0, 0, 10))
            );
         }

         advanceTimeBy(0.010);
         assertNotChanged();
         advanceTimeBy(0.490);
         assertNotChanged();
         advanceTimeBy(0.499);
         assertNotChanged();

         advanceTimeBy(0.001);
         assertThat(
            "speed modifier should change when time reaches a new second",
            control.speedModifier, equals (0.9)
         );
         assertThat(
            "arrival date should be 9 seconds from now",
            control.arrivalEvent.occuresIn, equals (9)
         );
      }

      [Test]
      public function eventsWhenTimeAdvancesButArrivalTimeDoesNotChange(): void {
         assertThat(
            "should not dispatch events when advancing time within "
               + "the same second",
            function (): void {
               advanceTimeBy(0.001);
               advanceTimeBy(0.499);
               advanceTimeBy(0.499);
            },
            not (causes (control) .toDispatch(
               event (SpeedControlEvent.SPEED_MODIFIER_CHANGE),
               event (SpeedControlEvent.ARRIVAL_TIME_CHANGE)
            ))
         );

         assertThat(
            "should dispatch SPEED_MODIFIER_CHANGE when advancing "
               + "time between seconds",
            function():void{ advanceTimeBy(0.001) },
            causes (control) .toDispatchEvent
               (SpeedControlEvent.SPEED_MODIFIER_CHANGE)
         );

         assertThat(
            "should not dispatch ARRIVAL_TIME_CHANGE",
            function():void{ advanceTimeBy(1) },
            not (causes (control) .toDispatchEvent
                    (SpeedControlEvent.ARRIVAL_TIME_CHANGE))
         );
      }

      [Test]
      public function eventsWhenTimeAdvancesButSpeedModifierDoesNotChange(): void {
         setUpInitialValues(1);

         assertThat(
            function():void{ advanceTimeBy(1) },
            not (causes (control) .toDispatchEvent
                    (SpeedControlEvent.SPEED_MODIFIER_CHANGE))
         );

         assertThat(
            function():void{ advanceTimeBy(1) },
            causes (control) .toDispatchEvent
               (SpeedControlEvent.ARRIVAL_TIME_CHANGE)
         );
      }

      [Test]
      public function eventsWhenArrivalTimeIsModifiedViaTimePartProperties(): void {
         assertThat(
            function():void{ control.arrivalSeconds = 5 },
            causes (control) .toDispatch(
               event (SpeedControlEvent.SPEED_MODIFIER_CHANGE),
               event (SpeedControlEvent.ARRIVAL_TIME_CHANGE)
            )
         );
      }

      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function advanceTimeBy(seconds: Number): void {
         DateUtil.now += seconds * 1000;
         control.update();
      }
   }
}
