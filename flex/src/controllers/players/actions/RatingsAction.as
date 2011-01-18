package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   /**
    * Gets ratings data. 
    */
   public class RatingsAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.ratings.disableAutoUpdate();
         ML.ratings.removeAll();
         ML.ratings = new ArrayCollection(cmd.parameters.ratings);
         ML.ratings.sort = new Sort();
         ML.ratings.sort.fields = [new SortField('points', true, true, true), 
                                   new SortField('name')];
         ML.ratings.refresh();
         
         var i: int = 0;
         for each (var player: Object in ML.ratings)
         {
            i++;
            player.rank = i;
         }
         
         NavigationController.getInstance().showRatings();
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}