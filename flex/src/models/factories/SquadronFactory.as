package models.factories
{
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   import models.unit.Unit;
   
   import utils.Objects;

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
         squad.playerId = unit.playerId;
         squad.player = unit.player;
         squad.createCurrentHop(unit.location);
         return squad;
      }
      
      
      public static function fromObject(data:Object) : MSquadron
      {
         var currentLoc:LocationMinimal = Objects.create(LocationMinimal, data.current);
         if (currentLoc.isSSObject)
         {
            currentLoc.setDefaultCoordinates();
         }
         var squad:MSquadron = Objects.create(MSquadron, data);
         squad.createCurrentHop(currentLoc);
         return squad;
      }
   }
}