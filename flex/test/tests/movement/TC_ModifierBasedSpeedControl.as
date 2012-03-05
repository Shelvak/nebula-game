package tests.movement
{
   import components.movement.speedup.BaseTripValues;
   import components.movement.speedup.ModifierBasedSpeedControl;
   import components.movement.speedup.SpeedupValues;
   import components.movement.speedup.events.SpeedControlEvent;

   import ext.hamcrest.date.dateEqual;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;

   import ext.hamcrest.object.equals;

   import models.time.events.MTimeEventEvent;

   import namespaces.change_flag;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.DateUtil;


   public class TC_ModifierBasedSpeedControl
   {
      private var baseValues: BaseTripValues;
      private var speedupValues: SpeedupValues;
      private var control: ModifierBasedSpeedControl;

      [Before]
      public function setUp(): void {
         MovementTestUtil.setUp();
         baseValues = new BaseTripValues(10000, 10);
         speedupValues = new SpeedupValues(baseValues);
         control = new ModifierBasedSpeedControl(
            baseValues, speedupValues
         );
      }

      [After]
      public function tearDown(): void {
         speedupValues = null;
         control = null;
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
            dateEqual(new Date(DateUtil.now + baseValues.tripTime * 1000))
         );
      }

      [Test]
      public function speedupValuesUsage(): void {
         assertThat(
            "should return SpeedupValues.speedModifierMin",
            control.speedModifierMin, equals (speedupValues.speedModifierMin)
         );
         assertThat(
            "should return SpeedupValues.speedModifierMax",
            control.speedModifierMax, equals (speedupValues.speedModifierMax)
         );
         control.speedModifier = 1.5;
         assertThat(
            "should modify SpeedupValues.speedModifier",
            speedupValues.speedModifier, equals (control.speedModifier)
         );
      }

      [Test]
      public function tripTimeDependsOnSpeedModifier(): void {
         control.speedModifier = 0.5;
         assertThat(
            "should take 1/2 of base trip time",
            control.arrivalEvent.occuresIn, equals (baseValues.tripTime / 2)
         );
      }

      [Test]
      public function reset(): void {
         control.speedModifier = 0.5;
         control.reset();
         assertThat(
            "should reset backing SpeedupValues",
            speedupValues.speedModifier, equals (1)
         );
      }

      [Test]
      public function events(): void {
         assertThat(
            function():void{ control.speedModifier = 0.5 },
            causes (control) .toDispatch(
               event (SpeedControlEvent.SPEED_MODIFIER_CHANGE),
               event (SpeedControlEvent.ARRIVAL_TIME_CHANGE)
            )
         );

         assertThat(
            function (): void {
               DateUtil.now += 1000;
               control.update();
            },
            allOf(
               causes (control) .toDispatchEvent
                  (SpeedControlEvent.ARRIVAL_TIME_CHANGE),
               not (causes (control) .toDispatchEvent
                       (SpeedControlEvent.SPEED_MODIFIER_CHANGE))
            )
         );
      }

      [Test]
      public function implementationOfIUpdatable(): void {
         control.resetChangeFlags();
         assertThat(
            "resetChangeFlags() should call arrivalEvent.resetChangeFlags()",
            control.arrivalEvent.change_flag::occuresAt, isFalse()
         );
         control.update();
         assertThat(
            "update() should call arrivalEvent.update()",
            control.arrivalEvent.change_flag::occuresAt, isTrue()
         );
      }
   }
}
