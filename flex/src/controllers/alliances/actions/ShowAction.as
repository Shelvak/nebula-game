package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import models.alliance.MAlliance;
   import models.player.MRatingPlayer;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Gets alliance data. 
    */
   public class ShowAction extends CommunicationAction
   {
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var ally: MAlliance = new MAlliance(cmd.parameters);
         for each (var player:MRatingPlayer in ally.players)
         {
            ally.totalWarPoints += player.warPoints;
            ally.totalSciencePoints += player.sciencePoints;
            ally.totalArmyPoints += player.armyPoints;
            ally.totalEconomyPoints += player.economyPoints;
            ally.totalPoints += player.points;
            ally.totalPlanetsCount += player.planetsCount;
            ally.totalVictoryPoints += player.victoryPoints;
            player.allianceOwnerId = ally.ownerId;
         }
         ally.players.sort = new Sort();
         ally.players.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ally.players.refresh();
         
         var i: int = 0;
         for each (player in ally.players)
         {
            i++;
            player.rank = i;
         }
         NavigationController.getInstance().openAlliance(ally);
      }
   }
}