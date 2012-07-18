package tests.planetcooldown
{
   import config.Config;
   
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ReinitiateCombatActionParams;
   
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.causesGlobalEvent;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;
   
   import factories.newUnit;
   
   import models.Owner;
   import models.cooldown.MCooldown;
   import models.planet.MPlanet;
   import models.planet.MPlanetCooldown;
   import models.planet.events.MPlanetCooldownEvent;
   import models.solarsystem.MSSObject;
   
   import org.hamcrest.Matcher;
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.text.containsStrings;
   import org.hamcrest.text.emptyString;
   
   import testsutils.LocalizerUtl;
   
   import utils.DateUtil;
   import utils.SingletonFactory;


   public class TC_MPlanetCooldown
   {
      private var ssObject: MSSObject;
      private var planet: MPlanet;
      private var cooldown: MPlanetCooldown;

      [Before]
      public function setUp(): void {
         Config.setConfig({
            "units.trooper.guns": [0, 1],
            "units.trooper.kind": "ground"});
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("Players", {"npc": "NPC"});
         LocalizerUtl.addBundle("PlanetCooldown", {
            "label.reinitiateButton": "Reinitiate",
            "message.noNpc": "No NPC units",
            "message.enemyOrNapPlanet": "ENEMY or NAP planet",
            "message.enemyOrNapUnit": "ENEMY or NAP unit",
            "message.noPlayerUnit": "no PLAYER unit"});
         DateUtil.now = 0;
         ssObject = new MSSObject();
         ssObject.id = 1;
         ssObject.cooldown = new MCooldown();
         ssObject.cooldown.endsEvent.occursAt = new Date(10000);
         planet = new MPlanet(ssObject);
         cooldown = new MPlanetCooldown(ssObject.cooldown, planet);
      }

      [After]
      public function tearDown(): void {
         LocalizerUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
         Config.setConfig(new Object());
      }


      /* ############################# */
      /* ### canReinitiateCombat() ### */
      /* ############################# */

      [Test]
      public function canReinitiateCombat_whenPlanetBelongsToPlayer(): void {
         ssObject.owner = Owner.PLAYER;
         assertCantReinitiateCombatWithoutNPCUnits();

         addNPCUnit();
         assertThat(
            "should allow reinitiate combat if NPC unit is in the planet",
            cooldown.canReinitiateCombat, isTrue());

         addUnit(2, Owner.ALLY);
         assertThat(
            "should allow reinitiate combat if alliance unit is in the planet",
            cooldown.canReinitiateCombat, isTrue());

         assertCantReinitiateCombatWithHostileUnits();
      }

      [Test]
      public function canReinitiateCombat_whenPlanetBelongsToAllyOrNPC(): void {
         for each (var owner: int in [Owner.ALLY, Owner.NPC]) {
            planet.units.removeAll();
            planet.invalidateUnitCachesAndDispatchEvent();

            ssObject.owner = owner;
            assertCantReinitiateCombatWithoutNPCUnits();

            addNPCUnit();
            assertCantReinitiateWithoutPlayerUnits();

            addUnit(2, Owner.PLAYER);
            assertThat(
               "should allow reinitiate combat if no ally unit is present",
               cooldown.canReinitiateCombat, isTrue());

            assertCantReinitiateCombatWithHostileUnits();
         }
      }

      [Test]
      public function canReinitiateCombat_whenPlanetBelongsToEnemyOrNap(): void {
         for each (var owner: int in [Owner.ENEMY, Owner.NAP]) {
            planet.units.removeAll();
            planet.invalidateUnitCachesAndDispatchEvent();
            ssObject.owner = owner;

            addNPCUnit();
            assertThat(
               "should not allow reinitiate combat in a hostile planet "
                  + "when player does not have units", cooldown.canReinitiateCombat, isFalse());

            addUnit(2, Owner.PLAYER);
            assertThat(
               "should not allow reinitiate combat in a hostile planet "
                  + "when player has units", cooldown.canReinitiateCombat, isFalse());
         }
      }

      private function assertCantReinitiateCombatWithHostileUnits(): void {
         addUnit(3, Owner.NAP);
         assertThat(
            "should not allow reinitiate combat if nap unit is present",
            cooldown.canReinitiateCombat, isFalse());

         planet.units.removeItemAt(2);
         addUnit(3, Owner.ENEMY);
         assertThat(
            "should not allow reinitiate combat if enemy unit is present",
            cooldown.canReinitiateCombat, isFalse());
      }

      private function assertCantReinitiateCombatWithoutNPCUnits(): void {
         assertThat(
            "should not allow reinitiate combat if no npc units are present in the planet",
            cooldown.canReinitiateCombat, isFalse());
      }

      private function assertCantReinitiateWithoutPlayerUnits(): void {
         assertThat(
            "should not allow reinitiate combat if not player units are present in the planet",
            cooldown.canReinitiateCombat, isFalse());
      }


      /* ########################## */
      /* ### reinitiateCombat() ### */
      /* ########################## */

      [Test]
      public function reinitiateCombat(): void {
         ssObject.owner = Owner.PLAYER;
         addNPCUnit();
         assertThat(
            "should dispatch REINITIATE_COMBAT command if can reinitiate",
            cooldown.reinitiateCombat,
            causesGlobalEvent (
               PlanetsCommand.REINITIATE_COMBAT,
               hasProperty("parameters", equals (new ReinitiateCombatActionParams (planet.id)))
            ));

         ssObject.owner = Owner.ENEMY;
         assertThat(
            "should do nothing if can't reinitiate combat",
            cooldown.reinitiateCombat, not (causesGlobalEvent (PlanetsCommand.REINITIATE_COMBAT)));
      }


      /* ########################################## */
      /* ### message_reinitiationRestrictions() ### */
      /* ########################################## */

      [Test]
      public function message_reinitiationRestrictions(): void {
         function actualMessage(): String {
            return cooldown.message_reinitiationRestrictions;
         }

         ssObject.owner = Owner.PLAYER;
         assertThat(
            "should tell that NPC presence is required to reinitiate combat",
            actualMessage(), equals ("No NPC units"));

         addNPCUnit();
         assertThat( "should be empty if can reinitiate battle", actualMessage(), emptyString() );

         for each (var hostileOwner: int in [Owner.ENEMY, Owner.NAP]) {
            ssObject.owner = hostileOwner;
            assertThat(
               "should tell that can't reinitiate battle in ENEMY or NAP planets",
               actualMessage(), equals ("ENEMY or NAP planet"));
         }

         ssObject.owner = Owner.PLAYER;
         for each (var hostileOwner: int in [Owner.ENEMY, Owner.NAP]) {
            addUnit(2, hostileOwner);
            assertThat(
               "should tell that can't reinitiate battle if ENEMY or NAP units are present",
               actualMessage(), equals ("ENEMY or NAP unit"));
            planet.units.removeItemAt(1);
            planet.invalidateUnitCachesAndDispatchEvent();
         }

         for each (var neutralOwner: int in [Owner.ALLY, Owner.NPC]) {
            ssObject.owner = neutralOwner;
            assertThat(
               "should tell that can't reinitiate battle if planet owned by NPC or "
                  + "ALLY and no player combat units are present",
               actualMessage(), equals ("no PLAYER unit"));
         }

         ssObject.owner = Owner.NAP;
         planet.units.removeAll();
         addUnit(1, Owner.ENEMY);
         assertThat(
            "should combine messages", actualMessage(),
            containsStrings("ENEMY or NAP planet", "ENEMY or NAP unit", "No NPC unit"));
      }

      /* ######################## */
      /* ### METADATA, EVENTS ### */
      /* ######################## */

      [Test]
      public function metadata(): void {
         assertThat(
            MPlanetCooldown, definesProperties ({
               "canReinitiateCombat":
                  withBindableTag(MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE),
               "message_reinitiationRestrictions":
                  withBindableTag(MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE) }));
      }

      [Test]
      public function events(): void {
         function causesEvent(): Matcher {
            return causes (cooldown) .toDispatchEvent (MPlanetCooldownEvent.CAN_REINITIATE_COMBAT_CHANGE)
         }

         assertThat(
            "changing ssObject.owner",
            function():void{ ssObject.owner = Owner.PLAYER; }, causesEvent());

         assertThat(
            "changing planet units",
            planet.invalidateUnitCachesAndDispatchEvent, causesEvent());
      }


      private function addNPCUnit(): void {
         addUnit(1, Owner.NPC);
      }

      private function addUnit(id: int, owner: int): void {
         planet.units.addItem(
            newUnit()
               .id(id).owner(owner).type("Trooper").level(1)
               .location(planet.getLocation(0, 0))
               .GET);
         planet.invalidateUnitCachesAndDispatchEvent();
      }
   }
}
