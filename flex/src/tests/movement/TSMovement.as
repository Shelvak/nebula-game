package tests.movement
{
   import tests.movement.tests.TCLocationMinimal;
   import tests.movement.tests.TCSquadron;
   import tests.movement.tests.TCSquadronsController;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSMovement
   {
      public var tcSquadron:TCSquadron;
      public var tcLocationMinimal:TCLocationMinimal;
      public var tcSquadronsController:TCSquadronsController;
   }
}