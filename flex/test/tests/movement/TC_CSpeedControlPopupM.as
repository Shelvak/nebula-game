package tests.movement
{
   import components.movement.speedup.CSpeedControlPopupM;
   import components.movement.speedup.events.SpeedControlEvent;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.player.Player;
   import models.unit.Unit;

   import namespaces.client_internal;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.DateUtil;
   import utils.SingletonFactory;


   public class TC_CSpeedControlPopupM
   {
      private var scpModel: CSpeedControlPopupM;
      private var player: Player;

      [Before]
      public function setUp(): void {
         DateUtil.now = new Date(2010, 0, 1).time;
         MovementTestUtil.setUp();
         scpModel = new CSpeedControlPopupM(10, 10);
         player = ModelLocator.getInstance().player;
      }

      [After]
      public function tearDown(): void {
         scpModel = null;
         player = null;
         MovementTestUtil.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function initialMode(): void {
         assertThat(
            "should be set to MODE_MODIFIER_BASED mode",
            scpModel.mode, equals (CSpeedControlPopupM.MODE_MODIFIER_BASED)
         );
      }

      [Test]
      public function modeSwitching(): void {
         scpModel.setTimeBasedMode();
         assertThat(
            "should be set to MODE_TIME_BASED mode",
            scpModel.mode, equals (CSpeedControlPopupM.MODE_TIME_BASED)
         );
         assertThat(
            "time-based controls should be active",
            scpModel.timeBasedControlsActive, isTrue()
         );
         assertThat(
            "modifier-based controls should not be active",
            scpModel.modifierBasedControlsActive, isFalse()
         );

         scpModel.setModifierBasedMode();
         assertThat(
            "should be set to MODE_MODIFIER_BASED mode",
            scpModel.mode, equals (CSpeedControlPopupM.MODE_MODIFIER_BASED)
         );
         assertThat(
            "time-based controls should not be active",
            scpModel.timeBasedControlsActive, isFalse()
         );
         assertThat(
            "modifier-based controls should be active",
            scpModel.modifierBasedControlsActive, isTrue()
         );
      }

      [Test]
      public function switchingBetweenModesRetainsSpeedModifierValue(): void {
         scpModel.setModifierBasedMode();

         scpModel.client_internal::setSpeedModifier(0.9);
         scpModel.setTimeBasedMode();
         assertThat(
            "switching from modifier-based to time-based mode retains "
               + "speedModifier value",
            scpModel.speedModifier, equals (0.9)
         );

         scpModel.client_internal::setSpeedModifier(0.8);
         assertThat(
            "switching from time-based to modifier-based mode retains "
               + "speedModifier value",
            scpModel.speedModifier, equals (0.8)
         );
      }

      [Test]
      public function modeSwitchingEvents(): void {
         assertThat(
            scpModel.setTimeBasedMode,
            causes (scpModel) .toDispatchEvent (SpeedControlEvent.MODE_CHANGE)
         );
         assertThat(
            scpModel.setModifierBasedMode,
            causes (scpModel) .toDispatchEvent (SpeedControlEvent.MODE_CHANGE)
         );
      }

      [Test]
      public function modifierBasedMode(): void {
         scpModel.setModifierBasedMode();
         advanceTimeBy(1);
         assertThat(
            "advancing time should not have changed speed modifier",
            scpModel.speedModifier, equals (1.0)
         );
         assertThat(
            "advancing time should not have changed trip time",
            scpModel.arrivesIn, equals (10)
         );
      }

      [Test]
      public function timeBaseMode(): void {
         scpModel.setTimeBasedMode();
         advanceTimeBy(1);
         assertThat(
            "advancing time should have reduced speed modifier",
            scpModel.speedModifier, equals (0.9)
         );
         assertThat(
            "advancing time should have reduced trip time",
            scpModel.arrivesIn, equals (9)
         );
      }

      [Test]
      public function reset(): void {
         scpModel.client_internal::setSpeedModifier(0.8);
         scpModel.setTimeBasedMode();
         advanceTimeBy(2);
         scpModel.reset();

         scpModel.setModifierBasedMode();
         assertThat(
            "when in modifier-based mode speed modifier should have default value",
            scpModel.speedModifier, equals (1)
         );
         scpModel.setTimeBasedMode();
         assertThat(
            "when in time-based mode speed modifier should have default value",
            scpModel.speedModifier, equals (1)
         );
      }
      
      [Test]
      public function changingSpeedModifier() : void {
         scpModel.setTimeBasedMode();
         assertThat(
            function():void{ advanceTimeBy(2) },
            causes (scpModel) .toDispatch(
               event (SpeedControlEvent.SPEED_MODIFIER_CHANGE),
               event (SpeedControlEvent.PLAYER_CREDS_CHANGE)
            )
         );
      }

      [Test]
      public function speedupCostVisibility(): void {
         scpModel.client_internal::setSpeedModifier(1.5);
         assertThat(
            "cost should not be visible if speedModifier >= 1",
            scpModel.showSpeedUpCost, isFalse()
         );

         scpModel.client_internal::setSpeedModifier(0.5);
         assertThat(
            "cost should be visible if speedModifier is less than 1",
            scpModel.showSpeedUpCost, isTrue()
         );
      }

      [Test]
      public function playerHasEnoughCreds() : void
      {
         const hops: int = 10;
         player.creds = Unit.getMovementSpeedUpCredsCost(0.25, hops);

         scpModel.client_internal::setSpeedModifier(1.0);
         assertThat(
            "should be enough creds if cost is 0",
            scpModel.playerHasEnoughCreds, isTrue()
         );

         scpModel.client_internal::setSpeedModifier(0.75);
         assertThat(
            "should be enough creds if cost is exact amount of creds player has",
            scpModel.playerHasEnoughCreds, isTrue()
         );

         scpModel.client_internal::setSpeedModifier(0.5);
         assertThat(
            "should not be enough creds if player has less creds than speedUpCost",
            scpModel.playerHasEnoughCreds, isFalse()
         );

         assertThat(
            "should dispatch PLAYER_CREDS_CHANGE event when player.creds changes",
            function (): void {
               player.creds = Unit.getMovementSpeedUpCredsCost(0.75, hops)
            },
            causes (scpModel) .toDispatchEvent
               (SpeedControlEvent.PLAYER_CREDS_CHANGE)
         );
         assertThat(
            "playerHasEnoughCreds should be updated when player.creds changes",
            scpModel.playerHasEnoughCreds, isTrue()
         );
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function advanceTimeBy(seconds:int): void {
         DateUtil.now += seconds * 1000;
         scpModel.update();
      }
   }
}