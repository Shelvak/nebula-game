package tests.planetboss
{
   import config.Config;

   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.BgSpawnActionParams;

   import ext.hamcrest.collection.array;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.causesGlobalEvent;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;

   import models.ModelLocator;
   import models.Owner;
   import models.cooldown.MCooldown;
   import models.galaxy.Galaxy;
   import models.planet.MPlanetBoss;
   import models.planet.events.MPlanetBossEvent;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.solarsystem.SSKind;
   import models.time.MTimeEventFixedMoment;
   import models.unit.RaidingUnitEntry;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.hasProperty;

   import testsutils.LocalizerUtl;

   import utils.SingletonFactory;


   public class TC_MPlanetBoss
   {
      private function get galaxy(): Galaxy {
         return ModelLocator.getInstance().latestGalaxy;
      }

      private var planet: MSSObject;
      private var boss: MPlanetBoss;

      [Before]
      public function setUp(): void {
         Config.setConfig({
            "spawn.mini_battleground.units": [
               ["20 + 1 * counter / 4", "30 + 4 * counter / 2", "Gnat", 0],
               ["5 + 1 * counter / 2", "15 + 3 * counter / 5", "Glancer", 1]],
            "spawn.battleground.units": [
               ["10 + 1 * counter / 4", "20 + 4 * counter / 2", "Azure", 0],
               ["20 + 1 * counter / 2", "25 + 3 * counter / 5", "Trooper", 1]]
         });
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("PlanetBoss", {
            "title": "Title",
            "label.unitsList": "Units",
            "label.spawnButton": "Spawn"
         });

         ModelLocator.getInstance().latestGalaxy = new Galaxy();
         galaxy.battlegroundId = 100;

         const ss:MSolarSystem = new MSolarSystem();
         ss.id = 50;
         ss.kind = SSKind.BATTLEGROUND;
         galaxy.addObject(ss);

         planet = new MSSObject();
         planet.id = 10;
         planet.solarSystemId = 50;
         boss = new MPlanetBoss(planet);
      }

      [After]
      public function tearDown(): void {
         Config.setConfig({});
         LocalizerUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function units(): void {
         planet.solarSystemId = 50;
         planet.spawnCounter = 0;
         assertThat(
            "should use formulas for mini-battleground",
            boss.units, array(
               equals (new RaidingUnitEntry("Gnat", 20, 30, 1)),
               equals (new RaidingUnitEntry("Glancer", 5, 15, 1))
            )
         );

         planet.solarSystemId = 100;
         planet.spawnCounter = 1;
         assertThat(
            "should use formulas for battleground",
            boss.units, array(
               equals (new RaidingUnitEntry("Azure", 10, 22, 1)),
               equals (new RaidingUnitEntry("Trooper", 20, 25, 1))
            )
         );
      }

      [Test]
      public function spawn(): void {
         assertThat(
            "should dispatch BG_SPAWN command if canSpawnNow is true",
            boss.spawn,
            causesGlobalEvent(
               PlanetsCommand.BG_SPAWN,
               hasProperty ("parameters", equals (new BgSpawnActionParams(planet.id)))
            )
         );

         planet.owner = Owner.ALLY;
         assertThat(
            "should do nothing if canSpawnNow is false",
            boss.spawn,
            not (causesGlobalEvent(
               PlanetsCommand.BG_SPAWN,
               hasProperty ("parameters", equals (new BgSpawnActionParams(planet.id)))
            ))
         );
      }

      [Test]
      public function staticLabels(): void {
         assertThat( "title of a boss spawn panel", boss.title_panel, equals ("Title") );
         assertThat( "units list header", boss.label_unitsList, equals ("Units") );
         assertThat( "spawn button label", boss.label_spawnButton, equals ("Spawn") );
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MPlanetBoss,
            definesProperties({
               "units": withBindableTag (MPlanetBossEvent.UNITS_CHANGE),
               "canSpawn": withBindableTag (MPlanetBossEvent.CAN_SPAWN_CHANGE),
               "canSpawnNow": withBindableTag (MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE),
               "message_spawnAbility": withBindableTag (MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE)
            })
         );
      }

      [Test]
      public function events(): void {
         assertThat(
            "changing planet.spawnCounter",
            function():void{ planet.spawnCounter = 1; },
            causes (boss) .toDispatchEvent (MPlanetBossEvent.UNITS_CHANGE)
         );

         assertThat(
            "changing planet.nextSpawn",
            function():void{ planet.nextSpawn = new MTimeEventFixedMoment(); },
            causes (boss) .toDispatch(
               event (MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE),
               event (MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE))
         );

         assertThat(
            "changing planet.owner",
            function():void{ planet.owner = Owner.ENEMY; },
            causes (boss) .toDispatch(
               event (MPlanetBossEvent.CAN_SPAWN_CHANGE),
               event (MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE),
               event (MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE))
         );

         assertThat(
            "changing planet.cooldown",
            function():void{ planet.cooldown = new MCooldown(); },
            causes (boss) .toDispatch(
               event (MPlanetBossEvent.CAN_SPAWN_CHANGE),
               event (MPlanetBossEvent.CAN_SPAWN_NOW_CHANGE),
               event (MPlanetBossEvent.MESSAGE_SPAWN_ABILITY_CHANGE))
         );
      }
   }
}
