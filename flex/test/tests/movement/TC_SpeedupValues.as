package tests.movement
{
   import components.movement.speedup.BaseTripValues;
   import components.movement.speedup.SpeedupValues;
   import components.movement.speedup.events.SpeedControlEvent;

   import ext.hamcrest.events.causes;

   import ext.hamcrest.object.equals;

   import org.hamcrest.assertThat;


   public class TC_SpeedupValues
   {
      private var speedupValues: SpeedupValues;

      [Before]
      public function setUp(): void {
         MovementTestUtil.setUp();
         speedupValues = new SpeedupValues(new BaseTripValues(10, 10));
      }

      [After]
      public function tearDown(): void {
         MovementTestUtil.tearDown();
      }


      [Test]
      public function defaultValues(): void {
         assertThat( "cost", speedupValues.cost, equals (0) );
         assertThat( "speedModifier", speedupValues.speedModifier, equals (1) );
         assertThat(
            "speedModifierMin", speedupValues.speedModifierMin, equals (0.1)
         );
         assertThat(
            "speedModifierMax", speedupValues.speedModifierMax, equals (2.0)
         );
      }

      [Test]
      public function reset(): void {
         speedupValues.speedModifier = 1.5;
         speedupValues.reset();
         assertThat(
            "should reset speedModifier to default value",
            speedupValues.speedModifier, equals (1)
         );
      }

      [Test]
      public function speedModifierSilentlyHandlesOutOfRangeValues(): void {
         speedupValues.speedModifier = 3.0;
         assertThat(
            "too great value should be substituted with max",
            speedupValues.speedModifier, equals (speedupValues.speedModifierMax)
         );

         speedupValues.speedModifier = 0.0;
         assertThat(
            "too little value should be substituted with min",
            speedupValues.speedModifier, equals (speedupValues.speedModifierMin)
         );

         speedupValues.speedModifier = 1.0;
         assertThat(
            "value in range should not be changed",
            speedupValues.speedModifier, equals (1.0)
         );
      }

      [Test]
      public function costCalculation(): void {
         speedupValues.speedModifier = 1.5;
         assertThat(
            "slowing down does not cost anything",
            speedupValues.cost, equals (0)
         );

         speedupValues.speedModifier = 0.75;
         assertThat(
            "speedup cost is calculated using formula config",
            speedupValues.cost, equals (250)
         );

         speedupValues.speedModifier = 0.25;
         assertThat(
            "speedup cost should not exceed maximum",
            speedupValues.cost, equals(500)
         );
      }

      [Test]
      public function events(): void {
         assertThat(
            function():void{ speedupValues.speedModifier = 0.5 },
            causes (speedupValues) .toDispatchEvent
               (SpeedControlEvent.SPEED_MODIFIER_CHANGE)
         );
      }
   }
}
