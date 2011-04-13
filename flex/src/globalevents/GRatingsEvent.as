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
      
      public var player: String;
      
      public function GRatingsEvent(type:String, playerName: String = null)
      {
         if (type == FILTER_PLAYER)
         {
            player = playerName;
         }
         super(type);
      }
   }
}