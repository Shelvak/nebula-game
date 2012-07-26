package factories
{
   import models.Owner;
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.player.PlayerMinimal;
   
   import mx.collections.ArrayList;

   public final class SquadronBuilder
   {
      private const _squad: MSquadron = new MSquadron();
      public function get GET(): MSquadron {
         return _squad;
      }
      
      public function id(id: int): SquadronBuilder {
         _squad.id = id;
         return this;
      }
      
      public function stationary(): SquadronBuilder {
         return id(0);
      }
      
      public function player(player: PlayerMinimal): SquadronBuilder {
         _squad.player = player;
         return this;
      }
      
      public function route(route: MRoute): SquadronBuilder {
         _squad.route = route;
         return this;
      }
      
      public function owner(owner: int): SquadronBuilder {
         _squad.owner = owner;
         return this;
      }
      
      public function ownerIsPlayer(): SquadronBuilder {
         return owner(Owner.PLAYER);
      }
      
      public function ownerIsAlly(): SquadronBuilder {
         return owner(Owner.ALLY);
      }
      
      public function ownerIsEnemy(): SquadronBuilder {
         return owner(Owner.ENEMY);
      }
      
      public function ownerIsNPC(): SquadronBuilder {
         return owner(Owner.NPC);
      }
      
      public function ownerIsNAP(): SquadronBuilder {
         return owner(Owner.NAP);
      }
      
      public function currentHop(hop: MHop): SquadronBuilder {
         _squad.currentHop = hop;
         return this;
      }
      
      public function currentHopFrom(location: LocationMinimal): SquadronBuilder {
         _squad.createCurrentHop(location);
         return this;
      }
      
      public function units(units: Array): SquadronBuilder {
         _squad.units.addAll(new ArrayList(units));
         return this;
      }
      
      public function hops(hops: Array): SquadronBuilder {
         _squad.addAllHops(new ArrayList(hops));
         return this;
      }
   }
}