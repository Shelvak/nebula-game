package models.factories
{
   import models.BaseModel;
   import models.movement.MSquadron;
   import models.unit.Unit;
   
   import namespaces.client_internal;

   public class SquadronFactory
   {
      /**
       * Creates squadron form the given unit. Does not add that unit to squadron's units list.
       * Does not create or modify cached units list.
       */
      public static function fromUnit(unit:Unit) : MSquadron
      {
         var squad:MSquadron = new MSquadron();
         squad.id = unit.squadronId;
         squad.owner = unit.owner;
         squad.currentLocation = unit.location;
         squad.client_internal::createCurrentHop();
         return squad;
      }
      
      
      public static function fromObject(data:Object) : MSquadron
      {
         var squad:MSquadron = BaseModel.createModel(MSquadron, data);
         squad.client_internal::createCurrentHop();
         return squad;
      }
   }
}