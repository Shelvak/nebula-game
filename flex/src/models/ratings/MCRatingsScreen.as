package models.ratings
{
   import flash.events.EventDispatcher;
   
   import models.ModelLocator;
   import models.player.MRatingPlayer;
   import models.player.Player;
   import models.ratings.events.RatingsEvent;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   
   import utils.SingletonFactory;
   
   public class MCRatingsScreen extends EventDispatcher
   {
      public static function getInstance(): MCRatingsScreen
      {
         return SingletonFactory.getSingletonInstance(MCRatingsScreen);
      }
      
      public var source: ArrayCollection;
      
      [Bindable]
      public var ratings: ListCollectionView;
      
      private function refreshNumbers(): void
      {         
         for (var i: int = 1; i <= source.length; i++)
         {
            var model: MRatingPlayer = MRatingPlayer(source.getItemAt(i-1));
            model.nr = i;
         }
      }
      
      public function sortList(sortFields: Array): void
      {
         source.sort = new Sort();
         source.sort.fields = sortFields;
         source.refresh();
         refreshNumbers();
      }
      
      public var filterName: String;
      
      public function filterPlayer(playerName: String): void
      {
         if (playerName != null)
         {
            filterName = playerName;
            if (hasEventListener(RatingsEvent.RATINGS_FILTER))
            {
               dispatchEvent(new RatingsEvent(RatingsEvent.RATINGS_FILTER));
            }
         }
         else
         {
            filterName = null;
            playerName = null;
            if (hasEventListener(RatingsEvent.RATINGS_SCROLL))
            {
               dispatchEvent(new RatingsEvent(RatingsEvent.RATINGS_SCROLL));
            }
         }
      }
      
      public function getScrollPosition(height: int, rowHeight: int): int
      {
         var player: Player = ModelLocator.getInstance().player;
         for (var i: int = 0; i < ratings.length; i++)
         {
            var model: MRatingPlayer = MRatingPlayer(ratings.getItemAt(i));
            if (model.id == player.id)
            {
               return Math.min(ratings.length * rowHeight, 
                  Math.max(0, Math.round(i* rowHeight - (height/2))));
            }
         }
         return -1;
      }
   }
}