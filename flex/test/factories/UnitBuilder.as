package factories
{
   import models.Owner;
   import models.location.LocationMinimal;
   import models.player.PlayerMinimal;
   import models.unit.Unit;

   public final class UnitBuilder
   {
      private const _unit: Unit = new Unit();
      public function get GET(): Unit {
         return _unit;
      }
      
      public function id(id: int): UnitBuilder {
         _unit.id = id;
         return this;
      }
      
      public function location(loc: LocationMinimal): UnitBuilder {
         _unit.location = loc;
         return this;
      }
      
      public function playerId(id: int): UnitBuilder {
         _unit.playerId = id;
         return this;
      }
      
      public function player(player: PlayerMinimal): UnitBuilder {
         _unit.player = player;
         _unit.playerId = player.id;
         return this;
      }
      
      public function squadronId(id: int): UnitBuilder {
         _unit.squadronId = id;
         return this;
      }
      
      public function stationary(): UnitBuilder {
         return squadronId(0);
      }
      
      public function type(type: String): UnitBuilder {
         _unit.type = type;
         return this;
      }
      
      public function owner(owner: int): UnitBuilder {
         _unit.owner = owner;
         return this;
      }
      
      public function ownerIsPlayer(): UnitBuilder {
         return owner(Owner.PLAYER);
      }
      
      public function ownerIsAlly(): UnitBuilder {
         return owner(Owner.ALLY);
      }
      
      public function ownerIsEnemy(): UnitBuilder {
         return owner(Owner.ENEMY);
      }
      
      public function ownerIsNPC(): UnitBuilder {
         return owner(Owner.NPC);
      }
      
      public function ownerIsNAP(): UnitBuilder {
         return owner(Owner.NAP);
      }
      
      public function level(level: int): UnitBuilder {
         _unit.level = level;
         return this;
      }
      
      public function hp(hp: int): UnitBuilder {
         _unit.hp = hp;
         return this;
      }
   }
}