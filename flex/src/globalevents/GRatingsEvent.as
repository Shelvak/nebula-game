package globalevents
{
   public class GRatingsEvent extends GlobalEvent
   {
      /**
       * To refresh online checkbox in rating screen 
       */      
      public static const RATINGS_REFRESH:String = "ratingsRefresh";
      
      /**
       * To filter player if opening from notifications
       */      
      public static const FILTER_PLAYER:String = "ratingsFilter";
      
      /**
       * To refresh alliances ratings
       */      
      public static const ALLIANCE_RATINGS_REFRESH:String = "allyRatingsRefresh";
      
      /**
       * To filter alliance if opening from notifications
       */      
      public static const FILTER_ALLIANCE:String = "ratingsAllyFilter";
      
      public var filterName: String;
      
      public function GRatingsEvent(type:String, _filterName: String = null)
      {
         if (type == FILTER_PLAYER)
         {
            filterName = _filterName;
         }
         super(type);
      }
   }
}