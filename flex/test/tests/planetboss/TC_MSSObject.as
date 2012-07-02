package tests.planetboss
{
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.definesProperties;
   import ext.hamcrest.object.metadata.withBindableTag;

   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   import models.solarsystem.SSKind;
   import models.solarsystem.SSObjectType;
   import models.solarsystem.events.MSSObjectEvent;
   import models.time.MTimeEventFixedMoment;
   import models.time.events.MTimeEventEvent;

   import namespaces.change_flag;

   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.nullValue;

   import utils.DateUtil;
   import utils.SingletonFactory;


   public class TC_MSSObject
   {
      public var ssObject: MSSObject;
      public var galaxy: Galaxy;

      [Before]
      public function setUp(): void {
         DateUtil.now = 0;
         galaxy = new Galaxy();
         galaxy.battlegroundId = 100;
         ModelLocator.getInstance().latestGalaxy = galaxy;

         const ss: MSolarSystem = new MSolarSystem();
         ss.id = 50;
         ss.kind = SSKind.BATTLEGROUND;
         galaxy.addObject(ss);
      }

      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }

      [Test]
      public function bossInstanceCreation(): void {
         ssObject = newSSObject(SSObjectType.ASTEROID, 100);
         assertThat(
            "boss should not be created for non-planet type SS objects",
            ssObject.boss, nullValue()
         );

         ssObject = newSSObject(SSObjectType.PLANET, 10);
         assertThat(
            "boss should not be created for simple planets",
            ssObject.boss, nullValue()
         );

         ssObject = newSSObject(SSObjectType.PLANET, 100);
         assertThat(
            "boss should be created for battleground planets",
            ssObject.boss, not (nullValue())
         );

         ssObject = newSSObject(SSObjectType.PLANET, 50);
         assertThat(
            "boss should be created for mini-battleground planets",
            ssObject.boss, not (nullValue())
         );
      }

      [Test]
      public function updateAndResetChangeFlags(): void {
         ssObject = newSSObject(SSObjectType.PLANET, 100);
         ssObject.nextSpawn = new MTimeEventFixedMoment();
         ssObject.nextSpawn.occursAt = new Date(1000);

         assertThat(
            "update() should invoke nextSpawn.update()",
            ssObject.update,
            causes (ssObject.nextSpawn) .toDispatchEvent (MTimeEventEvent.OCCURS_IN_CHANGE)
         );

         ssObject.resetChangeFlags();
         assertThat(
            "resetChangeFlags() should invoke nextSpawn.resetChangeFlags()",
            ssObject.nextSpawn.change_flag::occursIn, isFalse()
         );

         DateUtil.now = 2000;
         ssObject.update();
         assertThat(
            "update() should destroy nextSpawn if it expired",
            ssObject.nextSpawn, nullValue()
         );
      }

      [Test]
      public function events(): void {
         ssObject = newSSObject(SSObjectType.PLANET, 100);

         assertThat(
            "changing spawnCounter",
            function():void{ ssObject.spawnCounter = 2; },
            causes (ssObject) .toDispatchEvent (MSSObjectEvent.SPAWN_COUNTER_CHANGE)
         );

         assertThat(
            "changing nextSpawn",
            function():void{ ssObject.nextSpawn = new MTimeEventFixedMoment(); },
            causes (ssObject) .toDispatchEvent (MSSObjectEvent.NEXT_SPAWN_CHANGE)
         );
      }

      [Test]
      public function metadata(): void {
         assertThat(
            MSSObject, definesProperties({
               "spawnCounter": withBindableTag (MSSObjectEvent.SPAWN_COUNTER_CHANGE),
               "nextSpawn": withBindableTag (MSSObjectEvent.NEXT_SPAWN_CHANGE)
            })
         );
      }

      private function newSSObject(type: String, solarSystemId: int): MSSObject {
         const ssObject: MSSObject = new MSSObject();
         ssObject.type = type;
         ssObject.solarSystemId = solarSystemId;
         return ssObject;
      }
   }
}
