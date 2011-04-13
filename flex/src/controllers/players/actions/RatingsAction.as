package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.ui.NavigationController;
   
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
         ML.ratings = new ArrayCollection(cmd.parameters.ratings);
         for each (var player:Object in ML.ratings)
         {
            player.points = player.warPoints +
               player.sciencePoints +
               player.armyPoints +
               player.economyPoints;
         }
         ML.ratings.sort = new Sort();
         ML.ratings.sort.fields = [new SortField('victoryPoints', true, true, true), 
            new SortField('points', true, true, true),
            new SortField('planetsCount', true, true, true),
            new SortField('name')];
         ML.ratings.refresh();
         
         var i: int = 0;
         for each (player in ML.ratings)
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