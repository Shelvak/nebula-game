package factories
{
   import models.Owner;
   import models.location.Location;
   import models.movement.MRoute;
   import models.player.PlayerMinimal;
   import models.time.MTimeEventFixedMoment;

   
   public final class RouteBuilder
   {
      private const _route: MRoute = new MRoute();
      public function get GET(): MRoute {
         return _route;
      }
      
      public function id(id: int): RouteBuilder {
         _route.id = id;
         return this;
      }
      
      public function player(player: PlayerMinimal): RouteBuilder {
         _route.player = player;
         return this;
      }
      
      public function owner(owner: int): RouteBuilder {
         _route.owner = owner;
         return this;
      }
      
      public function ownerIsPlayer(): RouteBuilder {
         return owner(Owner.PLAYER);
      }
      
      public function ownerIsAlly(): RouteBuilder {
         return owner(Owner.ALLY);
      }
      
      public function ownerIsEnemy(): RouteBuilder {
         return owner(Owner.ENEMY);
      }
      
      public function ownerIsNPC(): RouteBuilder {
         return owner(Owner.NPC);
      }
      
      public function ownerIsNAP(): RouteBuilder {
         return owner(Owner.NAP);
      }
      
      public function sourceLoc(location: Location): RouteBuilder {
         _route.sourceLocation = location;
         return this;
      }
      
      public function currentLoc(location: Location): RouteBuilder {
         _route.currentLocation = location;
         return this;
      }
      
      public function targetLoc(location: Location): RouteBuilder {
         _route.targetLocation = location;
         return this;
      }
      
      public function arrivalEvent(event: MTimeEventFixedMoment): RouteBuilder {
         _route.arrivalEvent = event;
         return this;
      }
      
      public function jumpsAtEvent(event: MTimeEventFixedMoment): RouteBuilder {
         _route.jumpsAtEvent = event;
         return this;
      }
   }
}