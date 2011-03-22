package globalevents
{
   public class GRatingsEvent extends GlobalEvent
   {
      /**
       * To refresh online checkbox in rating screen 
       */      
      public static const RATINGS_REFRESH:String = "ratingsRefresh";
      
      public function GRatingsEvent(type:String)
      {
         super(type);
      }
   }
}