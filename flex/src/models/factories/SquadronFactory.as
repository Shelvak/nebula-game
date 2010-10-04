package models.factories
{
   import models.BaseModel;
   import models.movement.MSquadron;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   
   import namespaces.client_internal;

   public class SquadronFactory
   {
      public static function fromUnit(unit:Unit) : MSquadron
      {
         var squad:MSquadron = new MSquadron();
         squad.id = unit.squadronId;
         squad.owner = unit.owner;
         squad.playerId = unit.playerId;
         squad.currentLocation = unit.location;
         squad.client_internal::createCurrentHop();
         return squad;
      }
      
      
      public static function fromObject(data:Object) : MSquadron
      {
         var squad:MSquadron = BaseModel.createModel(MSquadron, data);
         squad.client_internal::createCurrentHop();
         for (var unitType:String in data.cachedUnits)
         {
            squad.cachedUnits.addItem(new UnitEntry(unitType, data.cachedUnits[unitType]));
         }
         return squad;
      }
   }
}