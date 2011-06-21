package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.movement.MSquadron;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Informs client that status of player has changed.
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>changes</code> - array of <code>[player_id, status]</code> pairs</li>
    * </ul>
    * Here
    * <ul>
    *    <li><code>playerId</code> - id of player for which status is being changed</li>
    *    <li><code>status</code> - new status of player</li>
    * </ul>
    * </p>
    */
   public class StatusChangeAction extends CommunicationAction
   {
      public function StatusChangeAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var statuses:Object = new Object();
         for each (var entry:Array in cmd.parameters["changes"])
         {
            statuses[String(entry[0])] = entry[1];
         }
         
         // update planets in latest solar system
         if (ML.latestSolarSystem != null)
         {
            var ss:SolarSystem = ML.latestSolarSystem;
            for each (var object:MSSObject in ss.naturalObjects)
            {
               if (object.isOwned && statusChanged(statuses, object.player.id))
               {
                  object.owner = getStatus(statuses, object.player.id);
               }
            }
         }
         
         // update squadrons and routes
         for each (var squad:MSquadron in ML.squadrons)
         {
            if (statusChanged(statuses, squad.playerId))
            {
               squad.owner = getStatus(statuses, squad.playerId);
               if (squad.isHostile)
               {
                  squad.removeAllHopsButNext();
                  if (squad.route != null)
                  {
                     Collections.removeFirstEqualTo(ML.routes, squad.route);
                  }
               }
            }
         }
         
         // update units
         for each (var unit:Unit in ML.units)
         {
            if (statusChanged(statuses, unit.playerId))
            {
               unit.owner = getStatus(statuses, unit.playerId);
            }
         }
      }
      
      
      private function getStatus(statuses:Object, playerId:int) : int
      {
         return statuses[playerId];
      }
      
      
      private function statusChanged(statuses:Object, playerId:int) : Boolean
      {
         return statuses[playerId] != undefined;
      }
   }
}