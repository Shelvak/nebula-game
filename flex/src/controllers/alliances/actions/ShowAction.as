package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import models.alliance.MAlliance;
   
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
         ML.alliance = new MAlliance(cmd.parameters);
         for each (var player:Object in ML.alliance.players)
         {
            player.points = player.warPoints +
               player.sciencePoints +
               player.armyPoints +
               player.economyPoints;
            ML.alliance.totalWarPoints += player.warPoints;
            ML.alliance.totalSciencePoints += player.sciencePoints;
            ML.alliance.totalArmyPoints += player.armyPoints;
            ML.alliance.totalEconomyPoints += player.economyPoints;
            ML.alliance.totalPoints += player.points;
            ML.alliance.totalPlanetsCount += player.planetsCount;
            ML.alliance.totalVictoryPoints += player.victoryPoints;
         }
         ML.alliance.players.sort = new Sort();
         ML.alliance.players.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ML.alliance.players.refresh();
         
         var i: int = 0;
         for each (player in ML.alliance.players)
         {
            i++;
            player.rank = i;
         }
      }
   }
}