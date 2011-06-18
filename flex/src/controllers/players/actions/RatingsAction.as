package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import models.factories.RatingsPlayerFactory;
   import models.player.MRatingPlayer;
   
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
         ML.ratings = RatingsPlayerFactory.fromObjects(cmd.parameters.ratings);
         ML.ratings.sort = new Sort();
         ML.ratings.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ML.ratings.refresh();
         
         var i: int = 0;
         for each (var player: MRatingPlayer in ML.ratings)
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