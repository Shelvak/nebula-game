package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import models.factories.RatingsPlayerFactory;
   import models.player.MRatingPlayer;
   import models.ratings.MCRatingsScreen;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
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
         RS.ratings = RatingsPlayerFactory.fromObjects(cmd.parameters.ratings);
         RS.ratings.sort = new Sort();
         RS.ratings.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         RS.ratings.refresh();
         
         var i: int = 0;
         for each (var player: MRatingPlayer in RS.ratings)
         {
            i++;
            player.rank = i;
         }
         
         NavigationController.getInstance().showRatings(playerName);
         playerName = null;
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}