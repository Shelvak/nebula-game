package tests.movement
{
   import controllers.units.SquadronsController;

   import ext.hamcrest.collection.array;
   import ext.hamcrest.object.equals;

   import models.ModelLocator;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;

   import org.flexunit.asserts.fail;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;

   import utils.SingletonFactory;


   public class TC_SquadronsController
   {
      private var squadsCtrl: SquadronsController;
      private var squads: SquadronsList;

      [Before]
      public function setUp(): void {
         squadsCtrl = SquadronsController.getInstance();
         squads = ModelLocator.getInstance().squadrons;
      }

      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
      }


      [Test]
      public function addHopToSquadron(): void {
         const hop: MHop = newHop(0, 10, 10);
         const anotherHop: MHop = newHop(1, 11, 11);

         assertThat(
            "should ignore hop if there is no squad to add it to",
            function():void{ squadsCtrl.addHopToSquadron(hop) },
            not (throws (Error)) );

         const squad: MSquadron = newSquad(1, 0, 0);
         squad.addHop(hop);
         squads.addItem(squad);

         assertThat(
            "should ignore hop if another hop defining same location is already in squad",
            function():void{ squadsCtrl.addHopToSquadron(newHop(1, 10, 10)) },
            not (throws (Error)) );
         assertThat(
            "should not have added the hop with the same location",
            squad.hops, arrayWithSize (1) );

         squadsCtrl.addHopToSquadron(anotherHop);
         assertThat(
            "should have added new hop to squad",
            squad.hops, array (equals(hop), equals(anotherHop))
         );
      }

      [Test]
      public function addHopsToSquadrons(): void {
         fail();
         const squad: MSquadron = newSquad(1, 0, 0);
         const hop0: MHop = newHop(0, 1, 1);
         const hop1: MHop = newHop(1, 2, 2);
         squads.addItem(squad);
         squadsCtrl.addHopsToSquadrons([hop0, hop1]);
         assertThat(
            "should have added all hops to squad",
            MSquadron(squads.getFirst()).hops, array (hop0, hop1)
         );
      }

      private function newSquad(id:int, x: int, y: int): MSquadron {
         const squad: MSquadron = new MSquadron();
         squad.id = id;
         squad.createCurrentHop(new LocationMinimal(LocationType.GALAXY, 1, x, y));
         return squad;
      }

      private function newHop(index: int, x: int, y: int): MHop {
         const loc: LocationMinimal = new LocationMinimal(LocationType.GALAXY, 1, x, y);
         const hop: MHop = new MHop();
         hop.index = index;
         hop.routeId = 1;
         hop.location = loc;
         return hop;
      }
   }
}
