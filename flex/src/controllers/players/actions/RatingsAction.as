package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import mx.collections.ArrayCollection;
   
   /**
    * Gets ratings data. 
    */
   public class RatingsAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.ratings.disableAutoUpdate();
         ML.ratings.removeAll();
         var ratings: Array = cmd.parameters.ratings;
         ratings.sortOn('rank', Array.NUMERIC);
         var i: int = 0;
         for each (var player: Object in ratings)
         {
            i++;
            player.rank = i;
         }
         ML.ratings = new ArrayCollection(ratings);
         NavigationController.getInstance().showRatings();
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}