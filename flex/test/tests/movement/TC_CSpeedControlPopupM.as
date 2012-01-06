package tests.movement
{
   import components.movement.CSpeedControlPopupM;
   import components.movement.events.CSpeedControlPopupMEvent;
   
   import config.Config;
   
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.player.Player;
   import models.unit.Unit;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.number.closeTo;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   import utils.SingletonFactory;
   
   
   public class TC_CSpeedControlPopupM
   {
      public function TC_CSpeedControlPopupM()
      {
      }
      
      
      private var scpModel:CSpeedControlPopupM;
      private var player:Player;
      
      
      [Before]
      public function setUp() : void
      {
         Config.setConfig({
            "units.move.modifier.min": 0.1,
            "units.move.modifier.max": 2.0,
            "combat.cooldown.afterJump.duration": 60,
            "creds.move.speedUp": "200 * percentage * hop_count",
            "creds.move.speedUp.maxCost": 2500
         });
         scpModel = new CSpeedControlPopupM(10, 5);
         player = ModelLocator.getInstance().player;
      };
      
      
      [After]
      public function tearDown() : void
      {
         scpModel = null;
         player = null;
         SingletonFactory.clearAllSingletonInstances();
      };
      
      
      [Test]
      public function should_use_configuration_values() : void
      {
         assertThat( scpModel.speedModifierMin, equals (Config.getMinMovementSpeedModifier()) );
         assertThat( scpModel.speedModifierMax, equals (Config.getMaxMovementSpeedModifier()) );
      };
      
      
      [Test]
      public function speed_modifier_should_respect_limits() : void
      {
         scpModel.speedModifier = 3.0;
         assertThat(
            "too great value should be substituted with max",
            scpModel.speedModifier, equals (scpModel.speedModifierMax)
         );
         
         scpModel.speedModifier = 0.0;
         assertThat(
            "too little value should be substituted with min",
            scpModel.speedModifier, equals (scpModel.speedModifierMin)
         );
         
         scpModel.speedModifier = 1.0;
         assertThat(
            "value in range should not be changed",
            scpModel.speedModifier, equals (1.0)
         );
      };
      
      
      [Test]
      public function changing_speed_modifier_should_dispatch_events() : void
      {
         assertThat(
            "should dispatch SPEED_MODIFIER_CHANGE and PLAYER_CREDS_CHANGE events",
            function():void{ scpModel.speedModifier = 1.5 },
            causes (scpModel) .toDispatch (
               event (CSpeedControlPopupMEvent.SPEED_MODIFIER_CHANGE),
               event (CSpeedControlPopupMEvent.PLAYER_CREDS_CHANGE)
            )
         );
      };
      
      
      [Test]
      public function arrivalDate_should_have_speed_modifier_applied() : void
      {  
         scpModel.speedModifier = 1.0;
         assertThat(
            "should be equal to base trip time when modifier is 1.0",
            scpModel.arrivalDate.occuresIn, closeTo (10, 1)
         );
         
         scpModel.speedModifier = 0.5;
         assertThat(
            "should be equal to half of base trip time when modifier is 0.5",
            scpModel.arrivalDate.occuresIn, closeTo (5, 1)
         );
         
         scpModel.speedModifier = 2.0;
         assertThat(
            "should be equal to twice of base trip time when modifier is 2.0",
            scpModel.arrivalDate.occuresIn, closeTo (20, 1)
         );
      };
      
      
      [Test]
      public function should_reset_values_to_their_defaults() : void
      {
         scpModel.speedModifier = 1.5;
         scpModel.reset();
         assertThat(
            "speedModifier should be reset",
            scpModel.speedModifier, equals (1.0)
         );
      };
      
      
      [Test]
      public function speedUpCost_should_depend_on_speed_modifier_and_baseTripTime() : void
      {         
         scpModel.speedModifier = 1.0;
         assertThat(
            "speedUpCost should be 0 if speedModifier is 1.0",
            scpModel.speedUpCost, equals (0)
         );
         
         scpModel.speedModifier = 1.5;
         assertThat(
            "speedUpCost should be 0 if speedModifier is greater than 1.0",
            scpModel.speedUpCost, equals (0)
         );
         
         scpModel.speedModifier = 0.5;
         assertThat(
            "speedUpCost should be calculated using values from config",
            scpModel.speedUpCost, equals (Unit.getMovementSpeedUpCredsCost(0.5,
               scpModel.hopCount))
         );
         
         scpModel.speedModifier = 0.25;
         assertThat(
            "speedUpCost should be calculated using values from config",
            scpModel.speedUpCost, equals (Unit.getMovementSpeedUpCredsCost(0.75,
               scpModel.hopCount))
         );
      };
      
      
      [Test]
      public function cost_should_be_visible_only_if_speedModifier_is_less_than_one() : void
      {
         scpModel.speedModifier = 1.0;
         assertThat(
            "cost should not be visible if speedModifier >= 1.0",
            scpModel.showSpeedUpCost, isFalse()
         );
         
         scpModel.speedModifier = 0.5;
         assertThat(
            "cost should be visible if speedModifier < 1.0",
            scpModel.showSpeedUpCost, isTrue()
         );
      };
      
      
      [Test]
      public function playerHasEnoughCreds() : void
      {
         player.creds = Unit.getMovementSpeedUpCredsCost(0.5, scpModel.hopCount);
         
         scpModel.speedModifier = 1.0;
         assertThat(
            "should be enough creds if cost is 0",
            scpModel.playerHasEnoughCreds, isTrue()
         );
         
         scpModel.speedModifier = 0.5;
         assertThat(
            "should be enough creds if const is exact amount of creds player has",
            scpModel.playerHasEnoughCreds, isTrue()
         );
         
         scpModel.speedModifier = 0.25;
         assertThat(
            "should not be enough creds if player has less creds than speedUpCost",
            scpModel.playerHasEnoughCreds, isFalse()
         );
         
         assertThat(
            "should dispatch PLAYER_CREDS_CHANGE event when ModelLocator.player.creds changes",
            function():void{ player.creds =  Unit.getMovementSpeedUpCredsCost(0.75, scpModel.hopCount)},
            causes (scpModel) .toDispatchEvent (CSpeedControlPopupMEvent.PLAYER_CREDS_CHANGE)
         );
         assertThat(
            "playerHasEnoughCreds should be updated when ModelLocator.player.creds changes",
            scpModel.playerHasEnoughCreds, isTrue()
         );
      };
   }
}