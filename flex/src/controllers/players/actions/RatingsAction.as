package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;

   import models.factories.RatingsPlayerFactory;
   import models.player.MRatingPlayer;
   import models.ratings.MCRatingsScreen;

   import mx.collections.ListCollectionView;
   import mx.collections.SortField;

   import utils.remote.rmo.ClientRMO;

   /**
    * Gets ratings data. 
    */
   public class RatingsAction extends CommunicationAction
   {
      private var playerName: String = null;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         if (cmd.parameters)
         {
            playerName = String(cmd.parameters);
         }
         sendMessage(new ClientRMO({}));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var RS: MCRatingsScreen = MCRatingsScreen.getInstance();
         RS.source = RatingsPlayerFactory.fromObjects(cmd.parameters.ratings);
         if (ML.latestGalaxy.apocalypseHasStarted)
         {
            RS.sortList([new SortField('planetsCount', false, true, true),
               new SortField('bgPlanetsCount', false, true, true),
               new SortField('deathDate', false, true),
               new SortField('victoryPoints', false, true, true),
               new SortField('points', false, true, true),
               new SortField('name')]);
         }
         else
         {
            RS.sortList([new SortField('victoryPoints', false, true, true),
               new SortField('points', false, true, true),
               new SortField('planetsCount', false, true, true),
               new SortField('name')]);
         }
         RS.ratings = new ListCollectionView(RS.source);
         var i: int = 0;
         for each (var player: MRatingPlayer in RS.source)
         {
            i++;
            player.rank = i;
         }
         NavigationController.getInstance().showRatings(playerName);
         playerName = null;
      }
   }
}