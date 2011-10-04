package models.factories
{
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.time.MTimeEventFixedMoment;
   import models.unit.Unit;
   
   import utils.DateUtil;
   import utils.Objects;

   public class SquadronFactory
   {
      /**
       * Creates hostile <code>MRoute</code> from given <code>squad</code> and attaches the route to
       * the squadron. Route does not get added to the global list of routes nor should it.
       * 
       * @param squad
       * <ul>
       *    <li>Not null.</li>
       * </ul>
       * 
       * @param jumpsAt
       */
      public static function createHostileRoute(squad:MSquadron, jumpsAt:String) : MRoute {
         Objects.paramNotNull("squad", squad);
         var route:MRoute = new MRoute();
         route.id = squad.id;
         route.playerId = squad.playerId;
         route.player = squad.player;
         route.owner = squad.owner;
         attachJumpsAt(route, jumpsAt);
         squad.route = route;
         return route;
      }
      
      /**
       * Attaches <code>jumpsAt</code> (or removes existing if <code>null</code>) to the given route.
       * 
       * @param route
       * <ul>
       *    <li>Not null.</li>
       * </ul>
       * @param jumpsAt
       */
      public static function attachJumpsAt(route:MRoute, jumpsAt:String) : MRoute {
         Objects.paramNotNull("route", route);
         if (jumpsAt != null) {
            route.jumpsAtEvent = new MTimeEventFixedMoment();
            route.jumpsAtEvent.occuresAt = DateUtil.parseServerDTF(jumpsAt);
         }
         else {
            route.jumpsAtEvent = null;
         }
         return route;
      }
      
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
         var currentLoc:LocationMinimal = BaseModel.createModel(LocationMinimal, data.current);
         if (currentLoc.isSSObject) {
            currentLoc.setDefaultCoordinates();
         }
         var squad:MSquadron = BaseModel.createModel(MSquadron, data);
         squad.createCurrentHop(currentLoc);
         return squad;
      }
   }
}