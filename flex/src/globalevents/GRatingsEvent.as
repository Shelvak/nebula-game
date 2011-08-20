package globalevents
{
   public class GRatingsEvent extends GlobalEvent
   {
      /**
       * To refresh alliances ratings
       */      
      public static const ALLIANCE_RATINGS_REFRESH:String = "allyRatingsRefresh";
      
      public function GRatingsEvent(type:String)
      {
         super(type);
      }
   }
}