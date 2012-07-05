package factories
{
   import models.location.LocationMinimal;
   import models.unit.Unit;


   public function newActiveUnit(
      id: int, owner: int, type: String, location: LocationMinimal): Unit
   {
      const unit: Unit = new Unit();
      unit.id = id;
      unit.level = 1;
      unit.location = location;
      unit.owner = owner;
      unit.type = type;
      return unit;
   }
}
