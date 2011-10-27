package controllers.alliances.actions
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
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.allyRatings = RatingsPlayerFactory.fromObjects(cmd.parameters.ratings);
         ML.allyRatings.sort = new Sort();
         ML.allyRatings.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ML.allyRatings.refresh();
         
         MRatingPlayer.refreshRanks(ML.allyRatings);
         NavigationController.getInstance().showAllyRatings();
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}