package models.factories
{
   import models.BaseModel;
   import models.ModelsCollection;
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
         var source:Array = new Array();
         for (var unitType:String in data.cachedUnits)
         {
            source.push(new UnitEntry(unitType, data.cachedUnits[unitType]));
         }
         squad.cachedUnits = new ModelsCollection(source);
         return squad;
      }
   }
}