package models.unit
{
   import models.factories.UnitFactory;
   import models.location.Location;
   import models.player.PlayerMinimal;

   import mx.collections.ArrayCollection;

   import utils.Objects;


   public class MPositionedUnits
   {
      public function MPositionedUnits(_location: Object, units: Object, _player: PlayerMinimal)
      {
         cachedUnits = UnitFactory.createCachedUnits(units);
         location = Objects.create(Location, _location);
         player = _player;
      }
      
      [Bindable]
      public var location: Location;
      
      [Bindable]
      public var cachedUnits: ArrayCollection;
      
      [Bindable]
      public var player: PlayerMinimal;
   }
}