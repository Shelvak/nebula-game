package controllers.alliances.actions
{
   import components.alliance.AllianceScreenM;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.alliance.MAlliance;
   import models.player.MRatingPlayer;

   import mx.collections.Sort;
   import mx.collections.SortField;

   import utils.remote.rmo.ClientRMO;

   /**
    * Gets alliance data. 
    */
   public class ShowAction extends CommunicationAction
   {
      private var allyId: int;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         allyId = cmd.parameters.id;
         sendMessage(new ClientRMO(cmd.parameters));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         cmd.parameters.id = allyId;
         var ally: MAlliance = new MAlliance(cmd.parameters);
         for each (var player:MRatingPlayer in ally.players)
         {
            ally.totalWarPoints += player.warPoints;
            ally.totalSciencePoints += player.sciencePoints;
            ally.totalArmyPoints += player.armyPoints;
            ally.totalEconomyPoints += player.economyPoints;
            ally.totalPoints += player.points;
            ally.totalPlanetsCount += player.planetsCount;
            ally.totalBgPlanetsCount += player.bgPlanetsCount;
            ally.totalVictoryPoints += player.victoryPoints;
            player.allianceOwnerId = ally.ownerId;
         }
         ally.players.sort = new Sort();
         if (ML.latestGalaxy.apocalypseHasStarted)
         {
            ally.players.sort.fields = [
               AllianceScreenM.planetsCountField,
               AllianceScreenM.bgPlanetsCountField,
               AllianceScreenM.deathDayField,
               AllianceScreenM.allianceVpsField,
               AllianceScreenM.victoryPtsField,
               AllianceScreenM.pointsField,
               AllianceScreenM.nameField
            ];

            if (ally.invPlayers)
            {
               ally.invPlayers.sort = new Sort();
               ally.invPlayers.sort.fields = [
                  AllianceScreenM.planetsCountField,
                  AllianceScreenM.bgPlanetsCountField,
                  AllianceScreenM.deathDayField,
                  AllianceScreenM.victoryPtsField,
                  AllianceScreenM.pointsField,
                  AllianceScreenM.nameField
               ];
               ally.invPlayers.refresh();
               MRatingPlayer.refreshRanks(ally.invPlayers);
            }
         }
         else
         {
            ally.players.sort.fields = [
               AllianceScreenM.allianceVpsField,
               AllianceScreenM.victoryPtsField,
               AllianceScreenM.pointsField,
               AllianceScreenM.planetsCountField,
               AllianceScreenM.bgPlanetsCountField,
               AllianceScreenM.nameField
            ];

            if (ally.invPlayers)
            {
               ally.invPlayers.sort = new Sort();
               ally.invPlayers.sort.fields = [
                  AllianceScreenM.victoryPtsField,
                  AllianceScreenM.pointsField,
                  AllianceScreenM.planetsCountField,
                  AllianceScreenM.bgPlanetsCountField,
                  AllianceScreenM.nameField
               ];
               ally.invPlayers.refresh();
               MRatingPlayer.refreshRanks(ally.invPlayers);
            }
         }
         ally.players.refresh();
         MRatingPlayer.refreshRanks(ally.players);
         ASM.alliance = ally;
      }
      
      private function get ASM(): AllianceScreenM
      {
         return AllianceScreenM.getInstance();
      }
   }
}