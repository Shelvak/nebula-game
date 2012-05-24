package tests.planetboss
{
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.Owner;
   import models.cooldown.MCooldown;
   import models.galaxy.Galaxy;
   import models.planet.MPlanetBoss;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.time.MTimeEventFixedMoment;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import testsutils.LocalizerUtl;

   import utils.DateUtil;
   import utils.SingletonFactory;


   public class TC_MPlanetBoss_SpawnAbility
   {
      private var boss: MPlanetBoss;
      private var planet: MSSObject;
      private var galaxy: Galaxy;

      [Before]
      public function setUp(): void {
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("PlanetBoss", {
            "message.canSpawnNow": "Can spawn now",
            "message.canSpawnIn": "Can spawn in {0}",
            "message.canNotSpawn": "Can't spawn"
         });

         DateUtil.now = 0;

         galaxy = new Galaxy();
         galaxy.battlegroundId = 100;
         ModelLocator.getInstance().latestGalaxy = galaxy;

         planet = new MSSObject();
         planet.type = SSObjectType.PLANET;
         planet.id = 1;
         planet.solarSystemId = 100;
         planet.owner = Owner.NPC;
         planet.cooldown = null;

         boss = new MPlanetBoss(planet);
      }

      [After]
      public function tearDown(): void {
         LocalizerUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function canSpawn(): void {
         planet.owner = Owner.PLAYER;
         assertThat( "can spawn if planet belongs to player", boss.canSpawn, isTrue() );
         planet.owner = Owner.NPC;
         assertThat( "can spawn if planet belongs to NPC", boss.canSpawn, isTrue() );

         planet.owner = Owner.ALLY;
         assertThat( "can't spawn boss if does not belongs to player or NPC", boss.canSpawn, isFalse() );

         planet.owner = Owner.NPC;
         planet.cooldown = new MCooldown();
         assertThat( "can't spawn boss if cooldown is in effect", boss.canSpawn, isFalse() );

         planet.cooldown = null;
         planet.nextSpawn = new MTimeEventFixedMoment();
         planet.nextSpawn.occursAt = new Date(1000);
         assertThat( "can spawn when cooldown for next spawn is in effect", boss.canSpawn, isTrue() );
      }

      [Test]
      public function canSpawnNow(): void {
         planet.owner = Owner.ALLY;
         assertThat(
            "can't spawn now if canSpawn is false",
            boss.canSpawnNow, isFalse()
         );

         planet.owner = Owner.PLAYER;
         assertThat(
            "can spawn now if canSpawn is true and cooldown for next spawn is not in effect",
            boss.canSpawnNow, isTrue()
         );

         planet.nextSpawn = new MTimeEventFixedMoment();
         planet.nextSpawn.occursAt = new Date(10000);
         assertThat(
            "can't spawn now if cooldown for next spawn is in effect",
            boss.canSpawnNow, isFalse()
         );
      }

      [Test]
      public function spawnExplanationLabel(): void {
         planet.owner = Owner.PLAYER;
         assertThat(
            "message should indicate that user can spawn boss",
            boss.message_spawnAbility, equals ("Can spawn now")
         );

         planet.owner = Owner.ALLY;
         assertThat(
            "message should explain why user can't spawn boss to planet",
            boss.message_spawnAbility, equals ("Can't spawn")
         );

         planet.owner = Owner.NPC;
         planet.nextSpawn = new MTimeEventFixedMoment();
         planet.nextSpawn.occursAt = new Date(10000);
         assertThat(
            "message should state when will user be able to spawn boss",
            boss.message_spawnAbility, equals ("Can spawn in 10s")
         );
      }
   }
}
