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
      private var allyName: String = null;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         if (cmd.parameters)
         {
            allyName = String(cmd.parameters);
         }
         sendMessage(new ClientRMO({}));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.allyRatings = RatingsPlayerFactory.fromObjects(cmd.parameters.ratings);
         ML.allyRatings.sort = new Sort();
         ML.allyRatings.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ML.allyRatings.refresh();
         
         var i: int = 0;
         for each (var ally:MRatingPlayer in ML.allyRatings)
         {
            i++;
            ally.rank = i;
         }
         
         NavigationController.getInstance().showAllyRatings(allyName);
         allyName = null;
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}